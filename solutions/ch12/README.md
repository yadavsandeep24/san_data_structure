# Chapter 12 — Model Solutions

## P1: TTL + LRU hybrid cache

### Approach

Store entries as `(value, expiresAt)`. Keep a hash map for O(1) lookup and an LRU order structure (linked hash / `Map` insertion order / explicit list). On `get`: miss if absent or expired (delete expired). On hit, move to most-recent. On `put`: overwrite + touch; if over capacity, evict LRU until size fits, skipping the need to keep expired entries by purging on access and optionally before eviction.

### Complexity

- `get` / `put`: O(1) average with linked-hash / `Map` order
- Space: O(capacity)

### Edge cases

- `capacity < 1` — clamp to 1 or throw
- `put` with already-expired TTL — store then immediately miss on get (or reject); model rejects by not retaining usefully: still store; next get removes
- Duplicate keys — update value and expiry, treat as touch
- `now` injected for testability — do not call wall clock inside unit tests blindly

### Mobile note

Use for small API response caches on device. For bitmaps prefer platform `LruCache` / image loaders; still apply TTL at the HTTP or metadata layer.

### Kotlin

```kotlin
class TtlLruCache<K, V>(
    private val capacity: Int,
    private val clock: () -> Long = { System.currentTimeMillis() },
) {
    private data class Entry<V>(val value: V, val expiresAt: Long)

    private val map = object : LinkedHashMap<K, Entry<V>>(capacity, 0.75f, true) {
        override fun removeEldestEntry(eldest: MutableMap.MutableEntry<K, Entry<V>>?): Boolean =
            size > capacity
    }

    @Synchronized
    fun get(key: K): V? {
        val e = map[key] ?: return null
        if (clock() >= e.expiresAt) {
            map.remove(key)
            return null
        }
        return e.value // accessOrder already touched by get
    }

    @Synchronized
    fun put(key: K, value: V, ttlMillis: Long) {
        require(capacity >= 1)
        map[key] = Entry(value, clock() + ttlMillis)
        // removeEldestEntry handles capacity
    }

    @Synchronized
    fun size(): Int = map.size
}
```

### Swift

```swift
final class TtlLruCache<Key: Hashable, Value> {
    private struct Entry {
        var value: Value
        var expiresAt: TimeInterval
    }

    private let capacity: Int
    private let clock: () -> TimeInterval
    private var map: [Key: Entry] = [:]
    private var order: [Key] = [] // 0 = LRU

    init(capacity: Int, clock: @escaping () -> TimeInterval = { Date().timeIntervalSince1970 }) {
        self.capacity = max(1, capacity)
        self.clock = clock
    }

    func get(_ key: Key) -> Value? {
        guard let e = map[key] else { return nil }
        if clock() >= e.expiresAt {
            removeKey(key)
            return nil
        }
        touch(key)
        return e.value
    }

    func put(_ key: Key, _ value: Value, ttl: TimeInterval) {
        if map[key] != nil {
            map[key] = Entry(value: value, expiresAt: clock() + ttl)
            touch(key)
            return
        }
        while order.count >= capacity {
            if let evict = order.first { removeKey(evict) }
        }
        map[key] = Entry(value: value, expiresAt: clock() + ttl)
        order.append(key)
    }

    private func touch(_ key: Key) {
        if let i = order.firstIndex(of: key) {
            order.remove(at: i)
            order.append(key)
        }
    }

    private func removeKey(_ key: Key) {
        map.removeValue(forKey: key)
        if let i = order.firstIndex(of: key) { order.remove(at: i) }
    }
}
```

### Dart

```dart
class TtlLruCache<K, V> {
  TtlLruCache(this.capacity, {int Function()? clock})
      : _clock = clock ?? (() => DateTime.now().millisecondsSinceEpoch);

  final int capacity;
  final int Function() _clock;
  final _map = <K, _Entry<V>>{};
  final _order = <K>[];

  V? get(K key) {
    final e = _map[key];
    if (e == null) return null;
    if (_clock() >= e.expiresAt) {
      _remove(key);
      return null;
    }
    _touch(key);
    return e.value;
  }

  void put(K key, V value, int ttlMillis) {
    final exp = _clock() + ttlMillis;
    if (_map.containsKey(key)) {
      _map[key] = _Entry(value, exp);
      _touch(key);
      return;
    }
    while (_order.length >= capacity) {
      _remove(_order.first);
    }
    _map[key] = _Entry(value, exp);
    _order.add(key);
  }

  void _touch(K key) {
    _order.remove(key);
    _order.add(key);
  }

  void _remove(K key) {
    _map.remove(key);
    _order.remove(key);
  }
}

class _Entry<V> {
  _Entry(this.value, this.expiresAt);
  final V value;
  final int expiresAt;
}
```

### TypeScript

```typescript
type Entry<V> = { value: V; expiresAt: number };

class TtlLruCache<K, V> {
  private map = new Map<K, Entry<V>>();
  constructor(
    private capacity: number,
    private clock: () => number = () => Date.now(),
  ) {
    this.capacity = Math.max(1, capacity);
  }

  get(key: K): V | undefined {
    const e = this.map.get(key);
    if (!e) return undefined;
    if (this.clock() >= e.expiresAt) {
      this.map.delete(key);
      return undefined;
    }
    this.map.delete(key);
    this.map.set(key, e);
    return e.value;
  }

  put(key: K, value: V, ttlMs: number): void {
    if (this.map.has(key)) this.map.delete(key);
    this.map.set(key, { value, expiresAt: this.clock() + ttlMs });
    while (this.map.size > this.capacity) {
      const lru = this.map.keys().next().value;
      this.map.delete(lru);
    }
  }
}
```

---

## P2: Two-level (memory + disk) cache API sketch

### Approach

Define `MemoryCache` (fast, trim-able) and `DiskCache` (slower fake store). `TwoLevelCache.get` checks L1, then L2; on L2 hit, **promote** into L1. `put` writes L1 and L2. `trimMemory` clears or halves L1 only.

### Complexity

- Memory ops: O(1); disk fake: O(1) map — real disk is I/O-bound
- Promotion: one L1 put

### Edge cases

- Disk hit of expired entry — treat as miss and delete both levels
- trim while empty — no-op
- put null — disallow or mean “invalidate”

### Mobile note

Never call real disk on the UI thread; expose `suspend` / async APIs in production. This sketch stays synchronous for clarity.

### Kotlin

```kotlin
interface MemoryCache<K, V> {
    fun get(key: K): V?
    fun put(key: K, value: V)
    fun remove(key: K)
    fun trimToHalf()
    fun clear()
}

interface DiskCache<K, V> {
    fun get(key: K): V?
    fun put(key: K, value: V)
    fun remove(key: K)
}

class MapMemoryCache<K, V>(private val capacity: Int) : MemoryCache<K, V> {
    private val map = object : LinkedHashMap<K, V>(capacity, 0.75f, true) {
        override fun removeEldestEntry(eldest: MutableMap.MutableEntry<K, V>?) = size > capacity
    }
    override fun get(key: K) = map[key]
    override fun put(key: K, value: V) { map[key] = value }
    override fun remove(key: K) { map.remove(key) }
    override fun clear() = map.clear()
    override fun trimToHalf() {
        val target = map.size / 2
        val it = map.entries.iterator()
        var seen = 0
        val n = map.size
        while (it.hasNext() && seen < n - target) {
            it.next(); it.remove(); seen++
        }
    }
}

class MapDiskCache<K, V> : DiskCache<K, V> {
    private val map = HashMap<K, V>()
    override fun get(key: K) = map[key]
    override fun put(key: K, value: V) { map[key] = value }
    override fun remove(key: K) { map.remove(key) }
}

enum class TrimLevel { MILD, CRITICAL }

class TwoLevelCache<K, V>(
    private val memory: MemoryCache<K, V>,
    private val disk: DiskCache<K, V>,
) {
    fun get(key: K): V? {
        memory.get(key)?.let { return it }
        val fromDisk = disk.get(key) ?: return null
        memory.put(key, fromDisk) // promote
        return fromDisk
    }

    fun put(key: K, value: V) {
        memory.put(key, value)
        disk.put(key, value)
    }

    fun invalidate(key: K) {
        memory.remove(key)
        disk.remove(key)
    }

    fun trimMemory(level: TrimLevel) {
        when (level) {
            TrimLevel.MILD -> memory.trimToHalf()
            TrimLevel.CRITICAL -> memory.clear()
        }
    }
}
```

### Swift

```swift
protocol MemoryCache {
    associatedtype Key: Hashable
    associatedtype Value
    func get(_ key: Key) -> Value?
    func put(_ key: Key, _ value: Value)
    func remove(_ key: Key)
    func trimToHalf()
    func clear()
}

protocol DiskCache {
    associatedtype Key: Hashable
    associatedtype Value
    func get(_ key: Key) -> Value?
    func put(_ key: Key, _ value: Value)
    func remove(_ key: Key)
}

enum TrimLevel { case mild, critical }

final class TwoLevelCache<M: MemoryCache, D: DiskCache>
where M.Key == D.Key, M.Value == D.Value {
    private let memory: M
    private let disk: D
    init(memory: M, disk: D) {
        self.memory = memory
        self.disk = disk
    }

    func get(_ key: M.Key) -> M.Value? {
        if let v = memory.get(key) { return v }
        guard let v = disk.get(key) else { return nil }
        memory.put(key, v)
        return v
    }

    func put(_ key: M.Key, _ value: M.Value) {
        memory.put(key, value)
        disk.put(key, value)
    }

    func trimMemory(_ level: TrimLevel) {
        switch level {
        case .mild: memory.trimToHalf()
        case .critical: memory.clear()
        }
    }
}
```

### Dart

```dart
abstract class MemoryCache<K, V> {
  V? get(K key);
  void put(K key, V value);
  void remove(K key);
  void trimToHalf();
  void clear();
}

abstract class DiskCache<K, V> {
  V? get(K key);
  void put(K key, V value);
  void remove(K key);
}

enum TrimLevel { mild, critical }

class TwoLevelCache<K, V> {
  TwoLevelCache(this.memory, this.disk);
  final MemoryCache<K, V> memory;
  final DiskCache<K, V> disk;

  V? get(K key) {
    final m = memory.get(key);
    if (m != null) return m;
    final d = disk.get(key);
    if (d == null) return null;
    memory.put(key, d);
    return d;
  }

  void put(K key, V value) {
    memory.put(key, value);
    disk.put(key, value);
  }

  void trimMemory(TrimLevel level) {
    switch (level) {
      case TrimLevel.mild:
        memory.trimToHalf();
      case TrimLevel.critical:
        memory.clear();
    }
  }
}
```

### TypeScript

```typescript
interface MemoryCache<K, V> {
  get(key: K): V | undefined;
  put(key: K, value: V): void;
  remove(key: K): void;
  trimToHalf(): void;
  clear(): void;
}

interface DiskCache<K, V> {
  get(key: K): V | undefined;
  put(key: K, value: V): void;
  remove(key: K): void;
}

type TrimLevel = "mild" | "critical";

class TwoLevelCache<K, V> {
  constructor(
    private memory: MemoryCache<K, V>,
    private disk: DiskCache<K, V>,
  ) {}

  get(key: K): V | undefined {
    const m = this.memory.get(key);
    if (m !== undefined) return m;
    const d = this.disk.get(key);
    if (d === undefined) return undefined;
    this.memory.put(key, d);
    return d;
  }

  put(key: K, value: V): void {
    this.memory.put(key, value);
    this.disk.put(key, value);
  }

  trimMemory(level: TrimLevel): void {
    if (level === "mild") this.memory.trimToHalf();
    else this.memory.clear();
  }
}
```

---

## P3: Cache hit-rate helper

### Approach

Increment `hits` or `misses` on each lookup outcome. `hitRate = hits / (hits + misses)` when total &gt; 0, else `0` (or `NaN` — pick 0 for mobile dashboards).

### Complexity

- Record / hitRate: O(1)
- Space: O(1)

### Edge cases

- Zero observations → 0.0
- Only misses → 0.0
- Integer division — use floating point

### Mobile note

Attach to your cache wrapper in debug/QA builds to verify warming after a scroll session. Do not log to disk every hit in production hot paths.

### Kotlin

```kotlin
class HitRateCounter {
    var hits: Long = 0
        private set
    var misses: Long = 0
        private set

    fun recordHit() { hits++ }
    fun recordMiss() { misses++ }

    fun hitRate(): Double {
        val t = hits + misses
        return if (t == 0L) 0.0 else hits.toDouble() / t
    }

    fun reset() {
        hits = 0
        misses = 0
    }
}

// usage inside cache get:
// val v = map[key]; if (v == null) { counter.recordMiss(); return null } else { counter.recordHit(); return v }
```

### Swift

```swift
final class HitRateCounter {
    private(set) var hits: Int = 0
    private(set) var misses: Int = 0

    func recordHit() { hits += 1 }
    func recordMiss() { misses += 1 }

    func hitRate() -> Double {
        let t = hits + misses
        return t == 0 ? 0 : Double(hits) / Double(t)
    }
}
```

### Dart

```dart
class HitRateCounter {
  int hits = 0;
  int misses = 0;

  void recordHit() => hits++;
  void recordMiss() => misses++;

  double hitRate() {
    final t = hits + misses;
    return t == 0 ? 0.0 : hits / t;
  }
}
```

### TypeScript

```typescript
class HitRateCounter {
  hits = 0;
  misses = 0;

  recordHit(): void {
    this.hits++;
  }
  recordMiss(): void {
    this.misses++;
  }
  hitRate(): number {
    const t = this.hits + this.misses;
    return t === 0 ? 0 : this.hits / t;
  }
}
```
