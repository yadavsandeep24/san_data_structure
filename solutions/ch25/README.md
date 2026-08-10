# Chapter 25 — Mini Project Reference Sketches

Condensed but usable architectures for the six projects in [`book/part-vii/25-mini-projects.md`](../../book/part-vii/25-mini-projects.md). Prefer production libraries where noted; these sketches teach the data structures.

---

## P1. LRU Image Memory Cache

**Architecture:** `Map<Key, Node>` + doubly linked list (MRU at head, LRU at tail). `get`/`put` splice in O(1).

### Kotlin

```kotlin
class ImageLruCache(private val capacity: Int) {
    private class Node(val key: String, var bytes: ByteArray) {
        var prev: Node? = null; var next: Node? = null
    }
    private val map = HashMap<String, Node>()
    private val head = Node("", ByteArray(0))
    private val tail = Node("", ByteArray(0))
    init { head.next = tail; tail.prev = head }

    private fun remove(n: Node) { n.prev!!.next = n.next; n.next!!.prev = n.prev }
    private fun addFront(n: Node) {
        n.next = head.next; n.prev = head
        head.next!!.prev = n; head.next = n
    }

    fun get(key: String): ByteArray? {
        val n = map[key] ?: return null
        remove(n); addFront(n); return n.bytes
    }
    fun put(key: String, bytes: ByteArray) {
        map[key]?.let { remove(it); map.remove(key) }
        val n = Node(key, bytes); addFront(n); map[key] = n
        if (map.size > capacity) {
            val lru = tail.prev!!; remove(lru); map.remove(lru.key)
        }
    }
}
```

### Swift

```swift
final class ImageLruCache {
    private final class Node {
        let key: String; var bytes: Data
        var prev: Node?; var next: Node?
        init(_ key: String, _ bytes: Data) { self.key = key; self.bytes = bytes }
    }
    private let capacity: Int
    private var map: [String: Node] = [:]
    private let head = Node("", Data()), tail = Node("", Data())
    init(_ capacity: Int) {
        self.capacity = capacity
        head.next = tail; tail.prev = head
    }
    private func remove(_ n: Node) { n.prev?.next = n.next; n.next?.prev = n.prev }
    private func addFront(_ n: Node) {
        n.next = head.next; n.prev = head
        head.next?.prev = n; head.next = n
    }
    func get(_ key: String) -> Data? {
        guard let n = map[key] else { return nil }
        remove(n); addFront(n); return n.bytes
    }
    func put(_ key: String, _ bytes: Data) {
        if let n = map[key] { remove(n); map.removeValue(forKey: key) }
        let n = Node(key, bytes); addFront(n); map[key] = n
        if map.count > capacity, let lru = tail.prev {
            remove(lru); map.removeValue(forKey: lru.key)
        }
    }
}
```

### Dart

```dart
class ImageLruCache {
  ImageLruCache(this.capacity);
  final int capacity;
  final _map = <String, _Node>{};
  final _head = _Node('', []);
  final _tail = _Node('', []);
  // wire head↔tail in constructor body if using late init pattern
  void _ensure() {
    _head.next ??= _tail;
    _tail.prev ??= _head;
  }
  List<int>? get(String key) {
    _ensure();
    final n = _map[key];
    if (n == null) return null;
    _remove(n); _addFront(n);
    return n.bytes;
  }
  void put(String key, List<int> bytes) {
    _ensure();
    final old = _map.remove(key);
    if (old != null) _remove(old);
    final n = _Node(key, bytes);
    _addFront(n); _map[key] = n;
    if (_map.length > capacity) {
      final lru = _tail.prev!;
      _remove(lru); _map.remove(lru.key);
    }
  }
  void _remove(_Node n) { n.prev!.next = n.next; n.next!.prev = n.prev; }
  void _addFront(_Node n) {
    n.next = _head.next; n.prev = _head;
    _head.next!.prev = n; _head.next = n;
  }
}
class _Node {
  _Node(this.key, this.bytes);
  final String key; List<int> bytes;
  _Node? prev, next;
}
```

### TypeScript

```typescript
class ImageLruCache {
  private map = new Map<string, { key: string; bytes: Uint8Array; prev?: any; next?: any }>();
  private head: any = { key: "", bytes: new Uint8Array() };
  private tail: any = { key: "", bytes: new Uint8Array() };
  constructor(private capacity: number) {
    this.head.next = this.tail; this.tail.prev = this.head;
  }
  private remove(n: any) { n.prev.next = n.next; n.next.prev = n.prev; }
  private addFront(n: any) {
    n.next = this.head.next; n.prev = this.head;
    this.head.next.prev = n; this.head.next = n;
  }
  get(key: string): Uint8Array | undefined {
    const n = this.map.get(key); if (!n) return;
    this.remove(n); this.addFront(n); return n.bytes;
  }
  put(key: string, bytes: Uint8Array): void {
    if (this.map.has(key)) { this.remove(this.map.get(key)); this.map.delete(key); }
    const n = { key, bytes }; this.addFront(n); this.map.set(key, n as any);
    if (this.map.size > this.capacity) {
      const lru = this.tail.prev; this.remove(lru); this.map.delete(lru.key);
    }
  }
}
```

**Production note:** Prefer `LruCache` / Coil / SDWebImage / `cached_network_image` — still know the DLL+map interview form.

---

## P2. Autocomplete Trie

### Kotlin

```kotlin
class AutoComplete {
    private class Node {
        val kids = HashMap<Char, Node>()
        var end = false
    }
    private val root = Node()
    fun insert(word: String) {
        var n = root
        for (c in word.lowercase()) n = n.kids.getOrPut(c) { Node() }
        n.end = true
    }
    fun suggest(prefix: String, k: Int): List<String> {
        var n: Node? = root
        for (c in prefix.lowercase()) { n = n?.kids[c] ?: return emptyList() }
        val out = mutableListOf<String>()
        fun dfs(cur: Node, path: StringBuilder) {
            if (out.size >= k) return
            if (cur.end) out.add(path.toString())
            for ((ch, child) in cur.kids) {
                path.append(ch); dfs(child, path); path.deleteCharAt(path.lastIndex)
                if (out.size >= k) return
            }
        }
        dfs(n!!, StringBuilder(prefix.lowercase()))
        return out
    }
}
```

### Swift

```swift
final class AutoComplete {
    private class Node { var kids: [Character: Node] = [:]; var end = false }
    private let root = Node()
    func insert(_ word: String) {
        var n = root
        for c in word.lowercased() {
            if n.kids[c] == nil { n.kids[c] = Node() }
            n = n.kids[c]!
        }
        n.end = true
    }
    func suggest(_ prefix: String, _ k: Int) -> [String] {
        var n: Node? = root
        let p = prefix.lowercased()
        for c in p { guard let nx = n?.kids[c] else { return [] }; n = nx }
        var out: [String] = []
        func dfs(_ cur: Node, _ path: inout String) {
            if out.count >= k { return }
            if cur.end { out.append(path) }
            for (ch, child) in cur.kids.sorted(by: { $0.key < $1.key }) {
                path.append(ch); dfs(child, &path); path.removeLast()
                if out.count >= k { return }
            }
        }
        var path = p; dfs(n!, &path); return out
    }
}
```

### Dart

```dart
class AutoComplete {
  final _root = _TNode();
  void insert(String word) {
    var n = _root;
    for (final r in word.toLowerCase().runes) {
      final c = String.fromCharCode(r);
      n = n.kids.putIfAbsent(c, () => _TNode());
    }
    n.end = true;
  }
  List<String> suggest(String prefix, int k) {
    var n = _root;
    final p = prefix.toLowerCase();
    for (final r in p.runes) {
      final c = String.fromCharCode(r);
      final next = n.kids[c];
      if (next == null) return [];
      n = next;
    }
    final out = <String>[];
    void dfs(_TNode cur, StringBuffer path) {
      if (out.length >= k) return;
      if (cur.end) out.add(path.toString());
      for (final e in cur.kids.entries) {
        path.write(e.key);
        dfs(e.value, path);
        path.length = path.length - 1;
        if (out.length >= k) return;
      }
    }
    dfs(n, StringBuffer(p));
    return out;
  }
}
class _TNode {
  final kids = <String, _TNode>{};
  bool end = false;
}
```

### TypeScript

```typescript
class AutoComplete {
  private root: any = { kids: new Map<string, any>(), end: false };
  insert(word: string): void {
    let n = this.root;
    for (const c of word.toLowerCase()) {
      if (!n.kids.has(c)) n.kids.set(c, { kids: new Map(), end: false });
      n = n.kids.get(c);
    }
    n.end = true;
  }
  suggest(prefix: string, k: number): string[] {
    let n = this.root;
    const p = prefix.toLowerCase();
    for (const c of p) { if (!n.kids.has(c)) return []; n = n.kids.get(c); }
    const out: string[] = [];
    const dfs = (cur: any, path: string) => {
      if (out.length >= k) return;
      if (cur.end) out.push(path);
      for (const [ch, child] of [...cur.kids.entries()].sort()) {
        dfs(child, path + ch);
        if (out.length >= k) return;
      }
    };
    dfs(n, p);
    return out;
  }
}
```

---

## P3. Offline-First Feed

**Architecture:** `items: Array<Entity>` + `ids: Set` / `Map<id, index>`; merge pages; diff by identity.

### Kotlin (core)

```kotlin
data class Entity(val id: String, val body: String)
data class Diff(val removals: List<String>, val inserts: List<Pair<Int, Entity>>, val updates: List<Entity>)

class FeedBuffer {
    private val items = mutableListOf<Entity>()
    private val index = HashMap<String, Int>()

    fun applyPage(page: List<Entity>, prepend: Boolean) {
        val fresh = page.filter { it.id !in index }
        if (prepend) {
            items.addAll(0, fresh)
        } else {
            items.addAll(fresh)
        }
        reindex()
    }
    private fun reindex() {
        index.clear()
        items.forEachIndexed { i, e -> index[e.id] = i }
    }
    fun snapshot(): List<Entity> = items.toList()

    fun diff(old: List<Entity>, new: List<Entity>): Diff {
        val oldIds = old.map { it.id }.toSet()
        val newMap = new.associateBy { it.id }
        val removals = old.map { it.id }.filter { it !in newMap }
        val inserts = new.withIndex().filter { it.value.id !in oldIds }.map { it.index to it.value }
        val updates = new.filter { it.id in oldIds && old[old.indexOfFirst { o -> o.id == it.id }].body != it.body }
        return Diff(removals, inserts, updates)
    }
}
```

### Swift / Dart / TypeScript

Same shape: ordered array + id set/map; `applyPage` filters unseen ids; `diff` uses set difference on ids and field compare for updates. Keep **stable ids** for list keys (Chapter 13).

```typescript
type Entity = { id: string; body: string };
class FeedBuffer {
  private items: Entity[] = [];
  private index = new Map<string, number>();
  applyPage(page: Entity[], prepend: boolean): void {
    const fresh = page.filter((e) => !this.index.has(e.id));
    this.items = prepend ? [...fresh, ...this.items] : [...this.items, ...fresh];
    this.reindex();
  }
  private reindex() {
    this.index.clear();
    this.items.forEach((e, i) => this.index.set(e.id, i));
  }
  snapshot() { return this.items.slice(); }
}
```

```dart
class FeedBuffer {
  final items = <Entity>[];
  final index = <String, int>{};
  void applyPage(List<Entity> page, {required bool prepend}) {
    final fresh = page.where((e) => !index.containsKey(e.id)).toList();
    if (prepend) items.insertAll(0, fresh); else items.addAll(fresh);
    _reindex();
  }
  void _reindex() {
    index.clear();
    for (var i = 0; i < items.length; i++) index[items[i].id] = i;
  }
}
class Entity { final String id, body; Entity(this.id, this.body); }
```

```swift
struct Entity: Equatable { let id: String; var body: String }
final class FeedBuffer {
    private(set) var items: [Entity] = []
    private var index: [String: Int] = [:]
    func applyPage(_ page: [Entity], prepend: Bool) {
        let fresh = page.filter { index[$0.id] == nil }
        items = prepend ? fresh + items : items + fresh
        reindex()
    }
    private func reindex() {
        index = Dictionary(uniqueKeysWithValues: items.enumerated().map { ($0.element.id, $0.offset) })
    }
}
```

---

## P4. Task Scheduler (Priority Queue)

### Kotlin

```kotlin
data class Task(val id: String, val priority: Int, val seq: Long, val run: () -> Unit)

class TaskScheduler {
    private var seq = 0L
    private val pq = java.util.PriorityQueue<Task>(compareBy<Task> { -it.priority }.thenBy { it.seq })
    private val cancelled = HashSet<String>()
    fun schedule(id: String, priority: Int, run: () -> Unit) {
        pq.add(Task(id, priority, seq++, run))
    }
    fun cancel(id: String) { cancelled.add(id) }
    fun runNext(): Boolean {
        while (pq.isNotEmpty()) {
            val t = pq.poll()!!
            if (t.id in cancelled) { cancelled.remove(t.id); continue }
            t.run(); return true
        }
        return false
    }
}
```

### Swift

Use a binary heap of `(priority, seq, id)`; higher priority first; lazy cancel set — same as Kotlin.

### Dart

```dart
class TaskScheduler {
  final _heap = <_T>[];
  final _cancelled = <String>{};
  var _seq = 0;

  void schedule(String id, int priority, void Function() run) {
    _heap.add(_T(id, priority, _seq++, run));
    _siftUp(_heap.length - 1);
  }

  void cancel(String id) => _cancelled.add(id);

  bool runNext() {
    while (_heap.isNotEmpty) {
      final t = _pop();
      if (_cancelled.remove(t.id)) continue;
      t.run();
      return true;
    }
    return false;
  }

  /// Higher priority first; tie-break earlier `seq`.
  bool _before(_T a, _T b) =>
      a.priority != b.priority ? a.priority > b.priority : a.seq < b.seq;

  void _siftUp(int i) {
    while (i > 0) {
      final p = (i - 1) >> 1;
      if (!_before(_heap[i], _heap[p])) break;
      final tmp = _heap[i];
      _heap[i] = _heap[p];
      _heap[p] = tmp;
      i = p;
    }
  }

  void _siftDown(int i) {
    for (;;) {
      var best = i;
      final l = i * 2 + 1, r = l + 1;
      if (l < _heap.length && _before(_heap[l], _heap[best])) best = l;
      if (r < _heap.length && _before(_heap[r], _heap[best])) best = r;
      if (best == i) break;
      final tmp = _heap[i];
      _heap[i] = _heap[best];
      _heap[best] = tmp;
      i = best;
    }
  }

  _T _pop() {
    final top = _heap.first;
    final last = _heap.removeLast();
    if (_heap.isNotEmpty) {
      _heap[0] = last;
      _siftDown(0);
    }
    return top;
  }
}

class _T {
  _T(this.id, this.priority, this.seq, this.run);
  final String id;
  final int priority;
  final int seq;
  final void Function() run;
}
```

### TypeScript

```typescript
type T = { id: string; priority: number; seq: number; run: () => void };
class TaskScheduler {
  private heap: T[] = [];
  private cancelled = new Set<string>();
  private seq = 0;
  private before(a: T, b: T) {
    return a.priority !== b.priority ? a.priority > b.priority : a.seq < b.seq;
  }
  schedule(id: string, priority: number, run: () => void) {
    this.heap.push({ id, priority, seq: this.seq++, run });
    this.siftUp(this.heap.length - 1);
  }
  cancel(id: string) { this.cancelled.add(id); }
  runNext(): boolean {
    while (this.heap.length) {
      const t = this.pop();
      if (this.cancelled.delete(t.id)) continue;
      t.run(); return true;
    }
    return false;
  }
  private siftUp(i: number) {
    const a = this.heap;
    while (i > 0) {
      const p = (i - 1) >> 1;
      if (!this.before(a[i], a[p])) break;
      [a[i], a[p]] = [a[p], a[i]];
      i = p;
    }
  }
  private siftDown(i: number) {
    const a = this.heap;
    for (;;) {
      let best = i;
      const l = i * 2 + 1, r = l + 1;
      if (l < a.length && this.before(a[l], a[best])) best = l;
      if (r < a.length && this.before(a[r], a[best])) best = r;
      if (best === i) break;
      [a[i], a[best]] = [a[best], a[i]];
      i = best;
    }
  }
  private pop(): T {
    const top = this.heap[0];
    const last = this.heap.pop()!;
    if (this.heap.length) {
      this.heap[0] = last;
      this.siftDown(0);
    }
    return top;
  }
}
```

---

## P5. Navigation Back Stack

### Four-language core (same API)

```kotlin
class NavStack {
    private val stack = ArrayDeque<String>()
    fun push(r: String) = stack.addLast(r)
    fun pop(): String? = if (stack.isEmpty()) null else stack.removeLast()
    fun peek(): String? = stack.lastOrNull()
    fun replace(r: String) { if (stack.isEmpty()) push(r) else { stack.removeLast(); stack.addLast(r) } }
    fun popToRoot() { while (stack.size > 1) stack.removeLast() }
    fun snapshot() = stack.toList()
}
```

```swift
final class NavStack {
    private var stack: [String] = []
    func push(_ r: String) { stack.append(r) }
    func pop() -> String? { stack.popLast() }
    func peek() -> String? { stack.last }
    func replace(_ r: String) { if stack.isEmpty { push(r) } else { stack[stack.count - 1] = r } }
    func popToRoot() { if !stack.isEmpty { stack = [stack[0]] } }
    func snapshot() -> [String] { stack }
}
```

```dart
class NavStack {
  final _stack = <String>[];
  void push(String r) => _stack.add(r);
  String? pop() => _stack.isEmpty ? null : _stack.removeLast();
  String? peek() => _stack.isEmpty ? null : _stack.last;
  void replace(String r) {
    if (_stack.isEmpty) push(r); else _stack[_stack.length - 1] = r;
  }
  void popToRoot() { if (_stack.length > 1) _stack.removeRange(1, _stack.length); }
  List<String> snapshot() => List.of(_stack);
}
```

```typescript
class NavStack {
  private stack: string[] = [];
  push(r: string) { this.stack.push(r); }
  pop() { return this.stack.pop(); }
  peek() { return this.stack[this.stack.length - 1]; }
  replace(r: string) {
    if (!this.stack.length) this.push(r); else this.stack[this.stack.length - 1] = r;
  }
  popToRoot() { if (this.stack.length) this.stack.length = 1; }
  snapshot() { return this.stack.slice(); }
}
```

---

## P6. Thread-Safe Request Coalescer

### Kotlin (coroutines)

```kotlin
class Coalescer<T> {
    private val mutex = kotlinx.coroutines.sync.Mutex()
    private val inflight = HashMap<String, kotlinx.coroutines.Deferred<T>>()

    suspend fun load(key: String, produce: suspend () -> T): T = coroutineScope {
        val deferred = mutex.withLock {
            inflight.getOrPut(key) { async { produce() } }
        }
        try {
            deferred.await()
        } finally {
            mutex.withLock { inflight.remove(key) }
        }
    }
}
```

Uses **`coroutineScope` + `Mutex`** — not `GlobalScope` — so work stays structured and cancellable with the caller (ViewModel/`viewModelScope`).

### Swift (actor)

```swift
actor Coalescer<T> {
    private var inflight: [String: Task<T, Error>] = [:]
    func load(_ key: String, produce: @escaping () async throws -> T) async throws -> T {
        if let t = inflight[key] { return try await t.value }
        let task = Task { try await produce() }
        inflight[key] = task
        defer { inflight[key] = nil }
        return try await task.value
    }
}
```

### Dart

```dart
class Coalescer<T> {
  final _inflight = <String, Future<T>>{};
  Future<T> load(String key, Future<T> Function() produce) {
    return _inflight.putIfAbsent(key, () async {
      try { return await produce(); }
      finally { _inflight.remove(key); }
    });
  }
}
```

### TypeScript

```typescript
class Coalescer<T> {
  private inflight = new Map<string, Promise<T>>();
  load(key: string, produce: () => Promise<T>): Promise<T> {
    const hit = this.inflight.get(key);
    if (hit) return hit;
    const p = produce().finally(() => this.inflight.delete(key));
    this.inflight.set(key, p);
    return p;
  }
}
```

**Test idea:** fire 100 parallel `load("x")` with a producer that sleeps 50ms and increments a counter — counter must end at **1**.

---

## Links

- Specs: [`book/part-vii/25-mini-projects.md`](../../book/part-vii/25-mini-projects.md)
- Interview bank: [`solutions/ch24`](../ch24/README.md)
