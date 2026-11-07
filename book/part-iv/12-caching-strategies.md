# Chapter 12 — Caching Strategies

A feed that re-downloads every avatar on every scroll. A product detail screen that re-parses the same JSON after every back navigation. An image carousel that looks smooth for thirty seconds, then the OS kills the process under memory pressure. Caching is the structure that sits between “fetch again” and “remember what we already paid for” — and on mobile, the wrong cache is as dangerous as no cache at all.

This chapter treats caches as first-class data structures: keyed stores with eviction policies, layered memory and disk, and explicit behavior when the system is starving for RAM.

---

## Mobile motivation

Network round-trips cost latency, radio wakeups, and battery. Decoding a large JPEG costs CPU and transient heap. Rebuilding a decoded bitmap from disk costs less than a fresh download, but still more than keeping a warm copy in memory. Every successful product app builds a **hierarchy**:

1. **Memory** — fastest, smallest, dies with the process (or sooner under pressure).
2. **Disk** — larger, survives process death, still bounded.
3. **Network / source of truth** — authoritative, slowest, most expensive.

If you only remember “HashMap of responses,” you will eventually ship an unbounded map of bitmaps and earn jetsam / LMK kills. The structure is not just the map — it is the **eviction policy** and the **layering**.

---

## Why cache

| Reason | What you avoid | Mobile cost if you skip it |
|--------|----------------|----------------------------|
| Latency | Waiting on radio / CDN | Blank placeholders, perceived slowness |
| Bandwidth | Re-downloading identical bytes | Metered networks, heat |
| CPU | Re-decoding images / re-parsing JSON | Frame drops on scroll |
| Battery | Radio and decoder wakeups | Drain while “just scrolling” |
| Offline | Empty screens with no connectivity | Hard failures when the user is on a train |

Caching is not free. Every entry occupies memory or flash. Stale entries can show wrong prices or outdated avatars. A cache without TTL or invalidation is a correctness bug wearing a performance costume.

**Rule of thumb:** cache **derived, expensive-to-rebuild** data (decoded images, compiled layouts, computed aggregates). Prefer **IDs + lightweight models** in scrolling lists; put heavy payloads behind a keyed cache (Chapter 3 foreshadowed this).

---

## Eviction policies

A cache of unlimited size is a leak. Eviction decides *which* key dies when you need room (or when an entry expires).

### FIFO — First In, First Out

Evict the oldest inserted entry, regardless of how often it was used.

- **Pros:** Simple queue + map; predictable.
- **Cons:** A frequently used early entry can be evicted while a one-shot late entry survives.
- **Mobile fit:** Rare for hot image caches; fine for short-lived request dedupe windows.

### LRU — Least Recently Used

Evict the entry that has not been accessed for the longest time. Every `get` / `put` that hits moves the key to “most recent.”

- **Pros:** Matches scroll locality — what you just saw tends to be seen again soon.
- **Cons:** A one-time scan of many keys (prefetching a long list) can flush the working set (“cache pollution”).
- **Mobile fit:** Default choice for memory image caches and API response caches.

**Classic structure:** `HashMap<Key, Node>` + doubly linked list (or linked hash map). Map gives O(1) lookup; list gives O(1) move-to-front and O(1) evict-tail.

### LFU — Least Frequently Used

Evict the entry with the lowest access count. Variants keep frequency lists so operations stay O(1) amortized.

- **Pros:** Protects “always hot” keys (app logo, current-user avatar) against one-shot traffic.
- **Cons:** New entries start at frequency 1 and may die quickly; aging/frequency decay is needed in practice.
- **Mobile fit:** Less common in image loaders; useful for config blobs or dictionaries that stay hot for the session.

### TTL — Time To Live

Each entry carries an expiry timestamp. On read, treat expired entries as misses (lazy eviction) or run a sweeper (eager).

- **Pros:** Bounds staleness for prices, auth tokens metadata, feature flags.
- **Cons:** Does not bound size by itself — pair with LRU/LFU/capacity.
- **Mobile fit:** Almost always combine **TTL + capacity policy** (hybrid).

### Policy comparison

| Policy | Evicts | Good for | Weak at |
|--------|--------|----------|---------|
| FIFO | Oldest insert | Simple buffers | Hot early keys |
| LRU | Coldest access | Scroll / recency | Scan pollution |
| LFU | Lowest count | Stable hot set | New keys, bursts |
| TTL | Expired by time | Freshness | Size alone |
| LRU+TTL | Cold or expired | Most mobile caches | Slightly more code |

---

## Complexity at a glance (LRU)

| Operation | Target | Notes |
|-----------|--------|-------|
| `get(key)` | O(1) average | Hash + move node to front |
| `put(key, value)` | O(1) average | Insert/update + maybe evict |
| `evict()` | O(1) | Remove LRU node |
| Space | O(capacity) | Map + list nodes |

Disk layers add I/O: treat them as O(size of payload) wall time, not O(1) CPU.

---

## Memory vs disk cache layers

Think in **two maps with different clocks**:

```text
                    miss
UI / loader  ──►  Memory cache  ──►  Disk cache  ──►  Network
                    │ hit              │ hit
                    ▼                  ▼
                 return             promote to memory, return
```

| Layer | Typical store | Survives process death? | Bound by |
|-------|---------------|-------------------------|----------|
| L1 memory | LRU map of decoded bitmaps / parsed models | No | Max entries, max bytes, OS pressure |
| L2 disk | Files / SQLite blobs keyed by URL hash | Yes (until cleared) | Max bytes, TTL, user “clear cache” |
| Source | HTTP / GraphQL / local DB | N/A | Rate limits, freshness |

**Promotion:** a disk hit should usually populate memory so the next scroll frame is cheap.  
**Write-through vs write-behind:** after a network fetch, write memory immediately; write disk asynchronously so the UI thread never blocks on flash.

**Key design:** use a stable key (canonical URL, `userId + version`, content hash). Changing query-string order should not create duplicate entries — normalize keys.

---

## How image loaders work (conceptually)

You rarely hand-roll a production image pipeline. You still must understand the structure so you configure it correctly.

| Library | Ecosystem | Mental model |
|---------|-----------|--------------|
| **Glide** | Android | Request → memory → disk → decode → transform → target; strong lifecycle binding |
| **Coil** | Android (Kotlin) | Similar layered cache; coroutine-friendly; memory LRU + disk |
| **SDWebImage** | iOS | Memory + disk caches; decode off main; category helpers on `UIImageView` |
| **cached_network_image** | Flutter | Provider + disk/memory cache via `ImageCache` / file store |
| **RN** (`FastImage`, etc.) | React Native | Native-backed caches under the bridge; JS still holds URIs, not bitmaps |

Shared pipeline (simplified):

1. **Request** with URL + size + transforms (circle crop, RGB565, etc.).
2. **Memory lookup** by key including size/transform — a 48dp thumbnail and a full-bleed hero are different keys.
3. On miss: **disk lookup**; on hit, decode (if stored encoded) and **promote** to memory.
4. On miss: **download**, write disk, decode at target size, put memory, deliver to the view.
5. On **cancel** (cell scrolled away): abort decode/download so you do not waste CPU on invisible work.

**Why size is part of the key:** caching a 4000px bitmap for a 40px avatar is a memory bug. Downsample at decode time; store the result under a size-aware key.

### In practice on Android: `ImageView` (Views) vs `AsyncImage` (Compose)

The cache structure above is identical in both toolkits — what changes is **how the loader learns the target size** and **when it cancels**. In a mixed app, XML screens and Compose screens should share **one** loader singleton (one memory LRU, one disk cache); a second `ImageLoader` per screen is a second cache competing for the same RAM.

| Concern | Views: Glide / Coil into an `ImageView` | Compose: Coil `AsyncImage` (Glide: experimental `GlideImage`) |
|---------|------------------------------------------|----------------------------------------------------------------|
| Request | `Glide.with(fragment).load(url).centerCrop().into(imageView)` or Coil's `imageView.load(url)` | `AsyncImage(model = url, contentDescription = …, contentScale = ContentScale.Crop, modifier = Modifier.size(48.dp))` |
| Target size (part of the cache key) | Waits for the `ImageView` to be measured; `wrap_content` can mean "decode at screen size" — give fixed dimensions or `override(w, h)` / `size(px)` | Resolved from the layout **constraints**; give the image a bounded size (`Modifier.size`, `fillMaxWidth().aspectRatio(…)`) or it may load at original size |
| Cancel when the row leaves | Loading into the same `ImageView` cancels its previous request (recycled holder + new bind); `Glide.with(fragment).clear(imageView)` in `onViewRecycled` releases the bitmap back to the pool | The request is tied to the composition: when the item scrolls out of a `LazyColumn` and leaves composition, the request is cancelled |
| Lifecycle | `Glide.with(fragment)` pauses/cancels with that Fragment; never pass an application context for a screen-scoped load | Composition lifetime; nothing extra to pass |
| Memory cache sizing | Configured once on the loader (below) — applies to every `ImageView` | Same loader, same numbers — applies to every `AsyncImage` |
| Memory pressure | Both libraries register `ComponentCallbacks2` and trim their memory LRU on `onTrimMemory` — keep your own caches doing the same | Same |

**Memory cache sizing applies to both.** Glide sizes its memory cache from screen dimensions (roughly a couple of screens' worth of bitmaps), capped by a fraction of the app's memory class; override it in an `AppGlideModule.applyOptions` with `builder.setMemoryCache(LruResourceCache(bytes))`. Coil takes a percentage of available app memory. Either way it is the bounded LRU from this chapter, measured in **bytes** (size-weighted), not entries.

**Kotlin — one loader for both toolkits (Coil 3)**

```kotlin
class App : Application(), SingletonImageLoader.Factory {
    override fun newImageLoader(context: PlatformContext): ImageLoader =
        ImageLoader.Builder(context)
            .memoryCache {
                MemoryCache.Builder()
                    .maxSizePercent(context, 0.20) // bounded, size-weighted LRU
                    .build()
            }
            .crossfade(true)
            .build()
}
```

(Coil 2 spells this `ImageLoaderFactory.newImageLoader()` and `MemoryCache.Builder(context).maxSizePercent(0.20)`; packages are `coil` instead of `coil3`.)

**Kotlin — Views: bind and release in a `RecyclerView`**

```kotlin
override fun onBindViewHolder(holder: RowHolder, position: Int) {
    val item = getItem(position)
    Glide.with(holder.itemView)               // lifecycle from the hosting Fragment/Activity
        .load(item.thumbUrl)
        .override(thumbPx)                    // size-aware key: decode at 48dp, not 4000px
        .centerCrop()
        .into(holder.binding.thumb)           // cancels whatever this ImageView loaded before
}

override fun onViewRecycled(holder: RowHolder) {
    Glide.with(holder.itemView).clear(holder.binding.thumb) // free the bitmap for reuse
}
```

**Kotlin — Compose: the same thumbnail in a `LazyColumn` row**

```kotlin
@Composable
fun Thumb(url: String) {
    AsyncImage(
        model = url,
        contentDescription = null,
        contentScale = ContentScale.Crop,
        modifier = Modifier.size(48.dp),      // bounded constraints → 48dp decode, size-aware key
    )
}
```

`RowHolder`, `thumbPx`, and `item.thumbUrl` are app-specific. Glide vs Coil is a team choice; the structure lesson (bounded, size-keyed LRU + cancellation) is the same for both.

---

## Eviction under memory pressure

Mobile OS killers do not politely wait for your LRU to drain.

| Platform | Signal | What good caches do |
|----------|--------|---------------------|
| Android | `ComponentCallbacks2.onTrimMemory` / `onLowMemory` | Clear or trim memory cache by level (`TRIM_MEMORY_RUNNING_LOW`, `UI_HIDDEN`, …) |
| iOS | `didReceiveMemoryWarning`, jetsam | Drop memory cache; keep disk; avoid retaining large images in view models |
| Flutter | `ImageCache` maximum size/count; pressure callbacks | `imageCache.clear()` / `clearLiveImages()` when appropriate |
| React Native | Native heap pressure; JS GC separately | Bound native image caches; do not keep base64 blobs in JS state |

**Practical policy:**

- Under mild pressure: evict half of LRU (or all entries below a recency threshold).
- Under critical pressure / UI hidden: clear **memory** entirely; leave **disk**.
- Never hold strong references from a global cache to `Activity` / `UIViewController` / `BuildContext` — cache values, not UI.

---

## Platform bridges

| Concern | Android | iOS | Flutter | React Native |
|---------|---------|-----|---------|--------------|
| Memory image cache | Glide/Coil / `LruCache` | SDWebImage / `NSCache` | `ImageCache` | Native libs / FastImage |
| Disk | Glide disk cache, OkHttp cache | URLCache / SD disk | file cache dirs | HTTP cache + native |
| Generic KV memory | `LruCache`, manual LinkedHashMap | `NSCache` (auto-evicts) | custom / `lru` packages | `Map` + manual LRU |
| HTTP response cache | OkHttp `Cache` | `URLCache` | `HttpClient` caches / Dio | fetch + native |

`NSCache` and Android `LruCache` already implement capacity-based eviction. Prefer them (or battle-tested loaders) over inventing a third broken LRU — unless you are learning or need TTL hybrid semantics the platform object lacks.

---

## Worked examples (four languages)

### Tiny LRU (capacity by entry count)

**Kotlin** — `LinkedHashMap` with access order:

```kotlin
class LruCache<K, V>(private val capacity: Int) :
    LinkedHashMap<K, V>(capacity, 0.75f, /* accessOrder = */ true) {

    override fun removeEldestEntry(eldest: MutableMap.MutableEntry<K, V>?): Boolean =
        size > capacity
}

fun demo() {
    val cache = LruCache<String, String>(2)
    cache["a"] = "1"
    cache["b"] = "2"
    cache["a"] // access → "a" becomes newest
    cache["c"] = "3" // evicts "b"
}
```

**Swift** — map + doubly linked list sketch via array of keys for teaching (O(n) move; production uses a class node list):

```swift
final class LruCache<Key: Hashable, Value> {
    private let capacity: Int
    private var map: [Key: Value] = [:]
    private var order: [Key] = [] // index 0 = LRU

    init(capacity: Int) { self.capacity = max(1, capacity) }

    func get(_ key: Key) -> Value? {
        guard let value = map[key] else { return nil }
        touch(key)
        return value
    }

    func put(_ key: Key, _ value: Value) {
        if map[key] != nil {
            map[key] = value
            touch(key)
            return
        }
        if order.count >= capacity, let evict = order.first {
            order.removeFirst()
            map.removeValue(forKey: evict)
        }
        map[key] = value
        order.append(key)
    }

    private func touch(_ key: Key) {
        if let i = order.firstIndex(of: key) {
            order.remove(at: i)
            order.append(key)
        }
    }
}
```

**Dart** — same teaching tradeoff as Swift: `_order.remove` is O(n) per touch. Prefer a node list (Chapter 4) or `LinkedHashMap`-style structure in production.

```dart
class LruCache<K, V> {
  LruCache(this.capacity);
  final int capacity;
  final _map = <K, V>{};
  final _order = <K>[]; // 0 = LRU

  V? get(K key) {
    final v = _map[key];
    if (v == null) return null;
    _touch(key);
    return v;
  }

  void put(K key, V value) {
    if (_map.containsKey(key)) {
      _map[key] = value;
      _touch(key);
      return;
    }
    if (_order.length >= capacity) {
      final evict = _order.removeAt(0);
      _map.remove(evict);
    }
    _map[key] = value;
    _order.add(key);
  }

  void _touch(K key) {
    _order.remove(key);
    _order.add(key);
  }
}
```

**TypeScript**

```typescript
class LruCache<K, V> {
  private map = new Map<K, V>(); // Map preserves insertion order
  constructor(private capacity: number) {}

  get(key: K): V | undefined {
    if (!this.map.has(key)) return undefined;
    const v = this.map.get(key)!;
    this.map.delete(key);
    this.map.set(key, v); // move to newest
    return v;
  }

  put(key: K, value: V): void {
    if (this.map.has(key)) this.map.delete(key);
    this.map.set(key, value);
    if (this.map.size > this.capacity) {
      const lru = this.map.keys().next().value;
      this.map.delete(lru);
    }
  }
}
```

### TTL check on read

```kotlin
data class Entry<V>(val value: V, val expiresAtMillis: Long)

fun <V> getIfFresh(map: Map<String, Entry<V>>, key: String, now: Long): V? {
    val e = map[key] ?: return null
    if (now >= e.expiresAtMillis) return null // treat as miss
    return e.value
}
```

Same idea in Swift/Dart/TS: store `expiresAt`; on `get`, compare to `now` before returning.

---

## Common mistakes

1. **Unbounded `HashMap` of images** — works in demos, kills production sessions.
2. **Caching full-resolution bitmaps for thumbnails** — size must be part of the key and decode path.
3. **TTL without capacity** — stale-safe but still OOM.
4. **Capacity without TTL** — bounded but shows yesterday’s price forever.
5. **Blocking the UI thread on disk** — disk hits belong off the main thread; memory hits can be synchronous if tiny.
6. **Caching UI objects** — leak activities/controllers; cache data.
7. **Ignoring memory warnings** — LRU alone is not enough when the OS demands RAM now.
8. **Using list `contains` to decide cache membership** — use the hash map; you already paid for O(1).
9. **One image loader per screen** — XML and Compose screens each building their own `ImageLoader` means two memory LRUs fighting for the same RAM; use one app-wide singleton.
10. **Unbounded image size** — `wrap_content` `ImageView` or an `AsyncImage` without bounded constraints can decode at full resolution; the size-aware key only helps if the size is known.

---

## Self-Check

Answers in Appendix D.

**12.1** Why is an unbounded in-memory image map a mobile crash waiting to happen even if lookups are O(1)?

**12.2** After a one-time prefetch of 500 product images, which policy better keeps that *freshly loaded* window in cache (what the user still sees)? Briefly contrast what happens to a previously hot set under each policy.

**12.3** Why do Glide/Coil/SDWebImage include **size/transform** in the cache key?

**12.4** What should a two-level cache do on a disk hit? On a critical memory warning?

**12.5** How does TTL alone fail to protect you from OOM?

---

## Practice Problems

Full model solutions (Kotlin, Swift, Dart, TypeScript), complexity, edge cases, and mobile notes:

→ **[`solutions/ch12/README.md`](../../solutions/ch12/README.md)**

1. **TTL + LRU hybrid cache** — Implement `get` / `put` with max capacity (LRU eviction) and per-entry TTL. Expired entries count as misses and should be removed when touched. Capacity eviction must skip already-expired logic cleanly.
2. **Two-level (memory + disk) cache API sketch** — Design interfaces/classes for L1 memory and L2 disk with `get`, `put`, promotion on disk hit, and `trimMemory(level)`. No need for real filesystem I/O — in-memory fakes are fine.
3. **Cache hit-rate helper** — Track hits and misses; expose `hitRate()` as hits / (hits + misses), safe when total is zero.

Attempt on paper first: which operations must be O(1)? What happens if `put` inserts an already-expired timestamp?

---

## What to remember

Caches are bounded associative structures with an eviction story. LRU matches scroll locality; TTL protects freshness; production mobile stacks layer memory over disk over network. Image loaders are that architecture with decode, size-aware keys, and lifecycle cancellation. Under memory pressure, drop memory aggressively and keep disk. Next: apply structural thinking to **list rendering** — how you update an on-screen array matters as much as how you cache its images.
