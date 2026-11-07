# Chapter 7 — Hash Tables (HashMap / Dictionary / Map)

## Mobile motivation

Your feed client gets a JSON array of 2,000 posts. The UI needs: “given `postId`, fetch the model in O(1)”, “skip IDs already shown”, and “cache avatar URLs so we do not re-decode the same bitmap”. That is the hash table’s job — **average O(1) insert, lookup, and delete** by key.

Every mobile stack ships a map type under a different name: Kotlin `HashMap` / `mutableMapOf`, Swift `Dictionary`, Dart `Map`, TypeScript `Map` (and plain objects for string keys). Misuse looks like “why is bind so slow?” — usually a linear scan of an array where a map of `id → index` would have been constant time. Overuse looks like “why did we OOM?” — caching every response forever without eviction.

## How a hash table works

A hash table stores key–value pairs in an array of **buckets**. To place a key:

1. Compute `hash(key)` → an integer.
2. Map that integer to a bucket index: `index = hash % capacity` (or a bit-mask when capacity is a power of two).
3. Store the pair in that bucket. If another key already lives there, resolve the **collision**.

### Hash functions

A good hash spreads keys uniformly. Language runtimes hash built-in types for you (`String`, `Int`, data classes with `equals`/`hashCode`). For custom keys you must define equality and hashing consistently: if `a == b`, then `hash(a) == hash(b)`.

| Property | Why it matters |
|----------|----------------|
| Deterministic | Same key always maps to the same bucket (within one process) |
| Uniform | Avoids one hot bucket becoming a linked list of length n |
| Fast | Hashing is on the critical path of every lookup |

### Collision strategies

| Strategy | Idea | Trade-off |
|----------|------|-----------|
| **Chaining** | Each bucket is a list (or tree) of entries | Simple; degrades toward O(n) if hashes collide badly |
| **Open addressing** | Probe other slots (linear/quadratic/double hash) | Cache-friendly; deletions need tombstones; load factor must stay lower |

You rarely implement this by hand in app code — but you *will* reason about **load factor** when a cache grows without bound or when interviewers ask “what happens when the table is full?”

### Load factor and resizing

**Load factor** α = `n / capacity` (entries ÷ buckets). When α exceeds a threshold (often ~0.75), the table allocates a larger array and **rehashes** every entry. Amortized insert stays O(1); a single resize is O(n) and can hitch the main thread if you grow a huge map on the UI thread.

```
before resize: capacity 16, n = 12, α = 0.75
after resize:  capacity 32, n = 12, α = 0.375  → then continue inserting
```

## Complexity at a glance

| Operation | Average | Worst (bad hash / adversarial) |
|-----------|---------|--------------------------------|
| get / containsKey | **O(1)** | O(n) |
| put / set | **O(1)** amortized | O(n) |
| remove | **O(1)** | O(n) |
| iterate all entries | O(n) | O(n) |
| space | O(capacity) | — |

Ordered / sorted variants (next section) change these numbers — do not assume every “map” is O(1).

## Language map cheat sheet

| Language | Unordered map | Ordered insertion | Sorted by key |
|----------|---------------|-------------------|---------------|
| Kotlin | `HashMap` / `mutableMapOf` | `LinkedHashMap` | `sortedMapOf` / `TreeMap` |
| Swift | `Dictionary` | (no insert-order guarantee; track keys separately) | sort keys when needed |
| Dart | `Map` (`{}` / `HashMap`) | `LinkedHashMap` (default `{}` is linked) | `SplayTreeMap` |
| TypeScript | `Map` | `Map` preserves insertion order | sort keys; or a tree lib |

**Dart gotcha:** literal `{}` is a `LinkedHashMap` — iteration order matches insertion. Kotlin `HashMap` does **not** promise order; use `LinkedHashMap` when the UI must walk keys in put-order (settings sections, form fields).

## Platform bridges

| Platform | Where hash tables already run |
|----------|-------------------------------|
| **Android** | `HashMap` for ID→ViewHolder caches; `LruCache` / Coil / Glide memory caches; `Bundle` key bags; Room entity lookups by primary key in memory layers. |
| **iOS** | `Dictionary` for diffable data source snapshots by ID; `NSCache` (evicts under memory pressure); UserDefaults key space; URLCache keyed by request. |
| **Flutter** | `Map` for widget keys / InheritedWidget lookups; `ImageCache`; JSON decode → `Map<String, dynamic>`. |
| **React Native** | JS `Map` or object for normalized Redux/Zustand stores (`entities.byId`); Hermes/JSC object shapes; bridge message demux by type string. |

### Caching, dedup, and lookups

Three patterns you will ship constantly:

1. **Lookup table** — `id → model` after decoding a list once; bind uses map, not `list.find`.
2. **Dedup** — `seen.add(id)` / `if (id in map) skip` while merging paginated pages.
3. **Memo / cache** — `key → expensiveResult` with size cap or TTL (pair with Chapter 12).

```kotlin
// Normalize API list once
fun indexById(posts: List<Post>): Map<String, Post> =
    posts.associateBy { it.id }
```

## Worked code: HashMap / Dictionary / Map

### Kotlin

```kotlin
val ages = hashMapOf<String, Int>()
ages["ada"] = 36
ages["linus"] = 54
println(ages["ada"])          // 36
println("ada" in ages)        // true
ages.remove("linus")

// Preserve insertion order for UI sections
val sections = LinkedHashMap<String, List<String>>()
sections["Account"] = listOf("Profile", "Security")
sections["Device"] = listOf("Notifications")
for ((title, rows) in sections) {
    // render title, then rows — order stable
}
```

### Swift

```swift
var ages: [String: Int] = [:]
ages["ada"] = 36
ages["linus"] = 54
print(ages["ada"] ?? -1)      // 36
print(ages["ada"] != nil)     // true
ages.removeValue(forKey: "linus")

// Insertion-ordered walk: keep a parallel key array, or rebuild from source of truth
let sectionOrder = ["Account", "Device"]
var sections: [String: [String]] = [
    "Account": ["Profile", "Security"],
    "Device": ["Notifications"],
]
for title in sectionOrder {
    let rows = sections[title] ?? []
    // render…
}
```

### Dart

```dart
final ages = <String, int>{};
ages['ada'] = 36;
ages['linus'] = 54;
print(ages['ada']);           // 36
print(ages.containsKey('ada'));
ages.remove('linus');

// Default Map is LinkedHashMap — iteration order == insertion order
final sections = <String, List<String>>{};
sections['Account'] = ['Profile', 'Security'];
sections['Device'] = ['Notifications'];
for (final e in sections.entries) {
  // e.key, e.value — stable order
}
```

### TypeScript

```typescript
const ages = new Map<string, number>();
ages.set('ada', 36);
ages.set('linus', 54);
console.log(ages.get('ada'));     // 36
console.log(ages.has('ada'));     // true
ages.delete('linus');

// Map iterates in insertion order
const sections = new Map<string, string[]>();
sections.set('Account', ['Profile', 'Security']);
sections.set('Device', ['Notifications']);
for (const [title, rows] of sections) {
  // render…
}

// Plain object: fine for string/symbol keys; prefer Map for frequent add/delete
const byId: Record<string, Post> = Object.create(null);
```

## Pattern: frequency map

Count occurrences in one pass — building block for anagrams, majority element, and “first unique”.

```kotlin
fun freq(s: String): Map<Char, Int> {
    val m = HashMap<Char, Int>()
    for (c in s) m[c] = (m[c] ?: 0) + 1
    return m
}
```

Same idea in Swift (`[Character: Int]`), Dart (`Map<String, int>` for graphemes carefully), and TS (`Map<string, number>`).

## Pattern: two-sum with a map

For each value `x` at index `i`, ask whether `target - x` was already seen. Store `value → index` as you scan. One pass, O(n) time, O(n) space — far better than nested loops on a 10k-product price list.

**Kotlin**

```kotlin
fun twoSum(nums: IntArray, target: Int): IntArray {
    val seen = HashMap<Int, Int>()
    for (i in nums.indices) {
        val need = target - nums[i]
        seen[need]?.let { return intArrayOf(it, i) }
        seen[nums[i]] = i
    }
    return intArrayOf()
}
```

**Swift**

```swift
func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    var seen: [Int: Int] = [:]
    for (i, x) in nums.enumerated() {
        if let j = seen[target - x] { return [j, i] }
        seen[x] = i
    }
    return []
}
```

**Dart**

```dart
List<int> twoSum(List<int> nums, int target) {
  final seen = <int, int>{};
  for (var i = 0; i < nums.length; i++) {
    final need = target - nums[i];
    final j = seen[need];
    if (j != null) return [j, i];
    seen[nums[i]] = i;
  }
  return [];
}
```

**TypeScript**

```typescript
function twoSum(nums: number[], target: number): number[] {
  const seen = new Map<number, number>();
  for (let i = 0; i < nums.length; i++) {
    const need = target - nums[i];
    if (seen.has(need)) return [seen.get(need)!, i];
    seen.set(nums[i], i);
  }
  return [];
}
```

## LinkedHashMap and ordered maps

When product requirements say “settings appear in the order we registered them” or “LRU: move accessed key to end”, you need **insertion order** or **access order**, not hash order.

| Need | Prefer |
|------|--------|
| Fast lookup only | HashMap / Dictionary / Map |
| Stable UI iteration | LinkedHashMap / Dart default Map / JS Map |
| Keys sorted alphabetically | TreeMap / SplayTreeMap / sort keys |
| Evict least recently used | LinkedHashMap access-order (Java), or explicit LRU list + map |

```kotlin
// Sketch: id → node, plus doubly linked list for LRU order (Chapter 12 expands this)
class LruSketch<K, V>(private val capacity: Int) {
    private val map = LinkedHashMap<K, V>(capacity, 0.75f, /* accessOrder */ true)
    fun get(key: K): V? = map[key]
    fun put(key: K, value: V) {
        map[key] = value
        if (map.size > capacity) {
            val eldest = map.entries.iterator().next()
            map.remove(eldest.key)
        }
    }
}
```

## Common mistakes

1. **Linear search instead of map** — `list.first { it.id == id }` inside `onBind` is O(n) per row.
2. **Mutable keys** — changing a key object after insert orphans the entry; use immutable IDs (String, Long, UUID).
3. **Forgetting null / missing** — Swift optional, Kotlin `get` vs `getValue`, Dart null, TS `undefined`; decide defaults explicitly.
4. **Unbounded caches** — maps that only ever `put` grow until jetsam / FOOM.
5. **Assuming iteration order** on Kotlin `HashMap` / unordered structures when painting UI.
6. **Using float keys** — `0.1 + 0.2` identity pain; prefer integers or normalized strings.
7. **Heavy work inside `hashCode`/`hashValue`** — every lookup pays for it.

## Self-Check

**7.1** What is load factor, and why do tables resize?

**7.2** Why must `equals` and `hashCode` agree for custom map keys?

**7.3** When do you pick `LinkedHashMap` over `HashMap` on Android?

**7.4** Give one mobile example of dedup with a hash table.

**7.5** What is the average and worst-case time for `get`?

*(Answers: Appendix D.)*

## Practice

1. **Two Sum** — return indices of two numbers that add to `target` — [solutions/ch07](../../solutions/ch07/README.md#p1-two-sum)
2. **Group by key / frequency** — group anagrams or count frequencies then emit groups — [solutions/ch07](../../solutions/ch07/README.md#p2-group-by-key--frequency)
3. **First unique character** — first index whose character appears once — [solutions/ch07](../../solutions/ch07/README.md#p3-first-unique-character)

Back: [Chapter 6 — Queues](../part-ii/06-queues-deques.md) · Next: [Chapter 8 — Sets](08-sets.md)
