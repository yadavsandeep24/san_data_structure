# Chapter 2 — Big-O Notation — Understanding It Practically

Profilers tell you what hurt *this* run. Big-O tells you what will hurt when the list grows from 50 items in QA to 50,000 in production. On mobile that prediction matters twice: once for time inside the frame budget, and again for space under memory pressure.

This chapter is practical complexity — enough theory to read code, enough mobile examples to refuse O(n²) on the main thread with confidence.

---

## Motivation: the 60fps math

At 60Hz, one frame ≈ **16.67ms**. Suppose binding one list row does a linear scan of a growing buffer:

- n = 100 → maybe fine
- n = 5,000 → same algorithm, fifty times more work
- called for every visible row on every partial update → multiply again

Big-O does not say “milliseconds.” It says how work **scales**. If your cost is Θ(n²) and n grows 10×, expect on the order of **100×** more operations — enough to turn a 2ms bind into a dropped frame, heat, and battery drain.

Space scales too. An O(n) auxiliary index can save the UI. An O(n²) matrix of precomputed pairs can OOM a phone that would have survived a smarter structure.

---

## Concept: what Big-O / Ω / Θ actually claim

We describe how resource use grows as input size **n** grows, ignoring constant factors and lower-order terms for the dominant term.

| Notation | Meaning | Plain English |
|----------|---------|---------------|
| **O(f(n))** | Upper bound (≤) | “Won’t grow faster than f, asymptotically” |
| **Ω(f(n))** | Lower bound (≥) | “Needs at least on the order of f” |
| **Θ(f(n))** | Tight bound | “Grows like f” (both O and Ω) |

In engineering talk people say “this is O(n)” when they mean “roughly linear.” In interviews, prefer Θ when you know the tight bound, and state **average vs worst** for hash tables.

### Time vs space on mobile

| Dimension | Why mobile cares |
|-----------|------------------|
| **Time** | Frame budget, ANR/watchdog, battery (CPU time ≈ joules) |
| **Space** | RAM caps, jetsam/OOM, GC/ARC pauses from allocation churn |

Servers often buy RAM. Phones reclaim your process. **Prefer algorithms with modest extra memory** when they still meet the time budget; when they do not, spend controlled space (indexes, sets) to protect the UI thread.

---

## Common complexities table

| Class | Name | Typical mobile examples |
|-------|------|-------------------------|
| O(1) | Constant | Array index, HashMap get (average), stack push |
| O(log n) | Logarithmic | Binary search on sorted array, balanced tree ops |
| O(n) | Linear | Single pass filter, building a Set from a list |
| O(n log n) | Linearithmic | Efficient comparison sorts |
| O(n²) | Quadratic | Nested loops over the same list; naive pairwise |
| O(2ⁿ) | Exponential | Naive subset / recursion without memo — avoid on device |

Constants matter in the small: an O(n) pass that allocates a huge object per element can lose to a tighter O(n) that reuses buffers. Still start with the class — then profile.

---

## How to read code for Big-O

1. **Find loops and recursion** — each nested loop over n is a multiply; recursion depth and branching matter.
2. **Find library calls** — `list.contains`, `indexOf`, `remove(at: 0)` often hide O(n).
3. **Separate setup from query** — building a HashSet is O(n); each later `contains` is O(1) average. Quote both.
4. **State the variable** — O(v + e) for graphs; O(n·k) if inner work depends on string length k.
5. **Worst vs average** — say it for hashes and quicksort-like algorithms.

### Tiny patterns

```text
for x in a:          → O(n)
  use(x)

for x in a:          → O(n²) if both ranges are size n
  for y in a:
    use(x, y)

for x in a:          → O(n) total if map.get is O(1) average
  map.get(x)
```

---

## Platform bridges: where complexity shows up

| API smell | Android | iOS | Flutter | React Native / JS |
|-----------|---------|-----|---------|-------------------|
| Linear membership | `List.contains` | `Array.contains` | `List.contains` | `Array.prototype.includes` |
| Mid/front remove | `ArrayList.remove(0)` | `removeFirst()` on Array | `list.removeAt(0)` | `splice(0, 1)` |
| Sort | `sort()` ~ O(n log n) | `sorted()` | `sort` / `..sort` | `sort` |
| Hash map | `HashMap` | `Dictionary` | `Map` | `Map` / object keys |

UI toolkits do **not** change your algorithmic class. `RecyclerView` and `FlatList` recycle views in roughly O(visible) bind work *per frame*; if each bind does O(n) work, you still have a scaling problem.

---

## Worked examples (four languages)

Count how often each id appears — classic linear pass, **Θ(n)** time, **O(u)** space for u unique keys.

### Kotlin — Θ(n) time, O(u) space

```kotlin
fun frequencies(ids: List<String>): Map<String, Int> {
    val counts = HashMap<String, Int>()           // extra space O(u)
    for (id in ids) {                             // Θ(n)
        counts[id] = (counts[id] ?: 0) + 1        // O(1) average
    }
    return counts
}
```

### Swift

```swift
func frequencies(_ ids: [String]) -> [String: Int] {
    var counts: [String: Int] = [:]               // O(u) space
    for id in ids {                               // Θ(n)
        counts[id, default: 0] += 1               // O(1) average
    }
    return counts
}
```

### Dart

```dart
Map<String, int> frequencies(List<String> ids) {
  final counts = <String, int>{};                 // O(u) space
  for (final id in ids) {                         // Θ(n)
    counts[id] = (counts[id] ?? 0) + 1;           // O(1) average
  }
  return counts;
}
```

### TypeScript

```typescript
function frequencies(ids: string[]): Map<string, number> {
  const counts = new Map<string, number>();       // O(u) space
  for (const id of ids) {                         // Θ(n)
    counts.set(id, (counts.get(id) ?? 0) + 1);    // O(1) average
  }
  return counts;
}
```

### Contrast: accidental quadratic

```kotlin
// Θ(n²) — for each id, scan the whole list again
fun countNaive(ids: List<String>, target: String): Int {
    var c = 0
    for (i in ids.indices) {
        for (j in ids.indices) {                  // nested
            if (ids[j] == target) c++
        }
    }
    return c // also logically wrong/wasteful — illustration only
}
```

Never ship the nested version on a scroll or search path.

---

## 60fps worked budget example

Assume a device where a simple hash lookup is ~50ns and a full string compare in a scan averages ~100ns.

| Approach | n = 2,000 rows × 200 selected IDs | Ballpark CPU |
|----------|-----------------------------------|--------------|
| Array scan per row | ~2,000 × 200 × 100ns | ~40ms — jank risk |
| Set lookup per row | ~2,000 × 50ns (+ O(m) build once) | ~0.1ms lookups — fits easily in 16ms |

Exact nanoseconds vary; the **ratio** does not. Big-O is how you see that ratio before you ship.

**Space trade:** one HashSet of 2,000 string references is tiny next to a single decoded bitmap — buy the set.

---

## Common mistakes

1. **Ignoring hidden loops in standard library** — `filter` + `contains` inside can be O(n²).
2. **Saying O(1) for hash ops without “average”** — worst-case degradation exists; still used everywhere for a reason.
3. **Optimizing constants before class** — fix n² before micro-tuning.
4. **Forgetting space** — memo tables and full list copies can kill mid-range devices.
5. **Measuring only on tiny fixtures** — asymptotic pain appears at production scale.

---

## Self-Check

Answers in Appendix D.

2.1 What is the difference between O(n) and Θ(n)?

2.2 Why might an O(n) algorithm with large allocations feel worse on mobile than an O(n log n) sort with tight memory use for moderate n?

2.3 Classify: nested loop `for i in 0..n; for j in 0..i` — is it still Θ(n²)?

2.4 You build a Dictionary once (O(n)) then answer 10,000 lookups. How should you describe the cost of the feature end-to-end?

2.5 At 120Hz, roughly how many milliseconds do you have per frame, and why does that change your tolerance for O(n) on the UI thread?

---

## Practice Problems

1. **Read the cost** — For each snippet in your language of choice, state time and extra space: (a) one loop pushing into a new array; (b) loop with `list.contains`; (c) sort then single pass.
2. **Budget call** — A search box filters 10,000 rows on every character on the JS/UI thread with a linear scan. Propose a complexity-aware redesign (index? debounce? background?).
3. **Space first** — Name a mobile feature where reducing space complexity matters more than shaving a log n factor in time.

Array-focused drills with full solutions: [`solutions/ch03/`](../../solutions/ch03/README.md) (after you read Chapter 3).

---

## What to remember

Big-O predicts scaling; mobile turns scaling into jank, heat, and kills. Label time and space, watch for hidden linear library calls, and keep per-frame work closer to O(1) or O(visible) than O(n) or O(n²). Next, Chapter 3 applies this lens to the structure underneath almost every list UI: arrays and dynamic arrays.
