# Chapter 15 — Prefix Sums & Difference Arrays

A prefix sum array answers "what is the total of `a[l..r]`?" in O(1) after one O(n) pass. Its mirror, the difference array, does the reverse: it applies "add `v` to every item in `[l..r]`" in O(1), and one pass at the end materializes all the updates. Add a hash map of prefix values and you can count or find subarrays with a given sum, even with negative numbers, where a sliding window breaks.

---

## Mobile motivation

- **Spending insights:** a wallet screen shows "you spent ₹X between the 3rd and the 17th" for any range the user drags on a chart. Scanning the range on every drag event is O(n) per frame. Reading a prefix array is O(1).
- **Bookings timeline:** 500 reservations, each covering a range of hours. "How many bookings overlap each hour?" A difference array answers it in O(n + hours), with no nested loop over bookings × hours.
- **Ledger reconciliation:** credits and debits (positive and negative) in time order. "Is there a stretch that nets to exactly zero?" That is prefix sums plus a hash map. A window can't do it because of the negative values.
- **Heatmaps:** sum of a rectangular region of a grid (map tiles, touch density) in O(1) with a 2D prefix table.

---

## The core identity

Define `prefix[0] = 0` and `prefix[i + 1] = prefix[i] + a[i]`, so `prefix[i]` is the sum of the first `i` items.

```text
a      =    [ 3,  1,  4,  1,  5]
prefix = [0,  3,  4,  8,  9, 14]

sum(a[l..r]) = prefix[r + 1] - prefix[l]
sum(a[1..3]) = prefix[4] - prefix[1] = 9 - 3 = 6   (1 + 4 + 1) ✓
```

Making the prefix array **one longer than the input** (with a leading 0) removes every `if (l == 0)` special case. Do this every time.

### Difference array, the inverse

To add `v` to `a[l..r]` lazily: `diff[l] += v`, `diff[r + 1] -= v`. After all updates, a running sum over `diff` produces the final values. Each update is O(1). Materializing is one O(n) pass.

```text
n = 5, add 2 to [1..3], add 5 to [2..4]
diff   = [0, 2, 5, 0, -2, -5]    (length n + 1)
result = [0, 2, 7, 7,  5]        (running sum of diff[0 until n])
```

### Prefix sum + hash map

"How many subarrays sum to k?" A subarray `a[l..r]` sums to `k` when `prefix[r + 1] - prefix[l] == k`, which is the same as `prefix[l] == prefix[r + 1] - k`. Walk left to right, keep a map from each prefix value to how many times it has appeared, and at each step add `count[current - k]`. Seed the map with `{0: 1}` so subarrays that start at index 0 are counted.

This works with **negative numbers**, because it never relies on the window shrinking. The full drill is [Ch 29 Q5 — Subarray Sum Equals K](../part-viii/29-interview-questions-q01-q10.md).

Variations:

| Want | Map stores | Seed |
|------|------------|------|
| Count of subarrays with sum k | prefix → count | `{0: 1}` |
| Longest subarray with sum k | prefix → **first** index seen | `{0: -1}` |
| Subarray sum divisible by m | `prefix mod m` → count (normalize negative mods) | `{0: 1}` |
| Equal 0s and 1s | treat 0 as −1, then "longest with sum 0" | `{0: -1}` |

---

## Complexity at a glance

| Operation | Naive | With prefix / diff |
|-----------|-------|--------------------|
| One range sum | O(r − l) | O(1) after O(n) build |
| q range sums | O(n·q) | O(n + q) |
| q range additions, then read all | O(n·q) | O(n + q) |
| Count subarrays with sum k | O(n²) | O(n) time, O(n) map |
| 2D rectangle sum (R×C grid) | O(R·C) per query | O(1) per query after O(R·C) build |

Prefix arrays are **immutable-friendly**. If the underlying values change often, use a Fenwick tree (binary indexed tree) instead: O(log n) per update and per query.

---

## How to recognize it

1. Many **range-sum queries** over data that doesn't change (or changes rarely).
2. Many **range updates**, then one read at the end (or a few).
3. "Count / longest subarray with sum = k" where values can be **negative**.
4. "Left side equals right side" or "balance point". Total minus prefix gives the suffix for free.
5. A grid where you need the sum of a rectangle many times.

---

## Platform bridges

| Platform | Where it shows up |
|----------|-------------------|
| **Android** | Chart libraries (MPAndroidChart, Vico) re-aggregate on every zoom. Precompute a prefix array of daily totals once in the ViewModel. In Compose, build it inside `remember(data)` so it isn't recomputed on recomposition. |
| **iOS** | Swift Charts range selection: build `prefix` when the data loads, then use O(1) lookups in the `chartXSelection` handler. Accelerate's `vDSP` can compute prefix sums (running sum) over large `Float`/`Double` buffers. |
| **Flutter** | `fl_chart` touch callbacks fire per pointer move. Read range totals from a prefix list instead of folding sublists. |
| **React Native** | Gesture handlers (Reanimated worklets) run per frame. A `Float64Array` prefix keeps lookups allocation-free on the UI thread. |

**Money note:** keep monetary prefix sums in **integer minor units** (Chapter 39). Summing floats accumulates error across thousands of transactions.

---

## Worked example 1: O(1) spend between two days

### Kotlin

```kotlin
class SpendRanges(daily: LongArray) {
    private val prefix = LongArray(daily.size + 1)
    init {
        for (i in daily.indices) prefix[i + 1] = prefix[i] + daily[i]
    }
    /** Total for days from..to inclusive, 0-based. */
    fun total(from: Int, to: Int): Long = prefix[to + 1] - prefix[from]
}
```

### Swift

```swift
struct SpendRanges {
    private var prefix: [Int]
    init(_ daily: [Int]) {
        prefix = [0]
        prefix.reserveCapacity(daily.count + 1)
        for x in daily { prefix.append(prefix.last! + x) }
    }
    func total(_ from: Int, _ to: Int) -> Int { prefix[to + 1] - prefix[from] }
}
```

### Dart

```dart
class SpendRanges {
  final List<int> _prefix;
  SpendRanges(List<int> daily) : _prefix = List<int>.filled(daily.length + 1, 0) {
    for (var i = 0; i < daily.length; i++) {
      _prefix[i + 1] = _prefix[i] + daily[i];
    }
  }
  int total(int from, int to) => _prefix[to + 1] - _prefix[from];
}
```

### TypeScript

```typescript
class SpendRanges {
  private readonly prefix: number[];
  constructor(daily: number[]) {
    this.prefix = new Array<number>(daily.length + 1).fill(0);
    for (let i = 0; i < daily.length; i++) this.prefix[i + 1] = this.prefix[i] + daily[i];
  }
  total(from: number, to: number): number {
    return this.prefix[to + 1] - this.prefix[from];
  }
}
```

**Complexity:** O(n) build, O(1) per query, O(n) space. **Mobile note:** build it when the data loads (off the main thread for large histories) and keep it in the ViewModel or state holder. Drag handlers then do two array reads.

---

## Worked example 2: bookings per hour with a difference array

Each booking is `[start, end]` (inclusive hours, `0 ≤ start ≤ end < hours`). Return how many bookings cover each hour.

### Kotlin

```kotlin
fun bookingsPerHour(hours: Int, bookings: List<IntArray>): IntArray {
    val diff = IntArray(hours + 1)
    for ((start, end) in bookings) {
        diff[start] += 1
        diff[end + 1] -= 1
    }
    val out = IntArray(hours)
    var running = 0
    for (h in 0 until hours) {
        running += diff[h]
        out[h] = running
    }
    return out
}
```

### Swift

```swift
func bookingsPerHour(_ hours: Int, _ bookings: [(start: Int, end: Int)]) -> [Int] {
    var diff = [Int](repeating: 0, count: hours + 1)
    for b in bookings {
        diff[b.start] += 1
        diff[b.end + 1] -= 1
    }
    var out = [Int](repeating: 0, count: hours)
    var running = 0
    for h in 0..<hours {
        running += diff[h]
        out[h] = running
    }
    return out
}
```

### Dart

```dart
List<int> bookingsPerHour(int hours, List<List<int>> bookings) {
  final diff = List<int>.filled(hours + 1, 0);
  for (final b in bookings) {
    diff[b[0]] += 1;
    diff[b[1] + 1] -= 1;
  }
  final out = List<int>.filled(hours, 0);
  var running = 0;
  for (var h = 0; h < hours; h++) {
    running += diff[h];
    out[h] = running;
  }
  return out;
}
```

### TypeScript

```typescript
function bookingsPerHour(hours: number, bookings: [number, number][]): number[] {
  const diff = new Array<number>(hours + 1).fill(0);
  for (const [start, end] of bookings) {
    diff[start] += 1;
    diff[end + 1] -= 1;
  }
  const out = new Array<number>(hours).fill(0);
  let running = 0;
  for (let h = 0; h < hours; h++) {
    running += diff[h];
    out[h] = running;
  }
  return out;
}
```

**Complexity:** O(b + hours) time vs O(b · hours) naive. **Mobile note:** the same idea draws a calendar's "busy density" strip, or works out how many downloads overlap each second of a session timeline.

---

## Prefix + hash map in code (Kotlin)

```kotlin
fun countSubarraysWithSum(a: IntArray, k: Int): Int {
    val seen = HashMap<Long, Int>().apply { put(0L, 1) }  // empty prefix
    var prefix = 0L
    var count = 0
    for (x in a) {
        prefix += x
        count += seen[prefix - k] ?: 0       // earlier prefixes that complete a sum-k run
        seen[prefix] = (seen[prefix] ?: 0) + 1
    }
    return count
}
```

Look up **before** inserting the current prefix. Otherwise, when `k == 0`, the empty subarray at the current position gets counted. The four-language version is [Ch 29 Q5](../part-viii/29-interview-questions-q01-q10.md).

---

## 2D prefix sums (rectangle queries)

`P[r + 1][c + 1] = grid[r][c] + P[r][c + 1] + P[r + 1][c] − P[r][c]`

Sum of rows `r1..r2`, columns `c1..c2` = `P[r2+1][c2+1] − P[r1][c2+1] − P[r2+1][c1] + P[r1][c1]`

```kotlin
class GridSums(grid: Array<IntArray>) {
    private val p = Array(grid.size + 1) { LongArray((grid.firstOrNull()?.size ?: 0) + 1) }
    init {
        for (r in grid.indices) for (c in grid[r].indices) {
            p[r + 1][c + 1] = grid[r][c] + p[r][c + 1] + p[r + 1][c] - p[r][c]
        }
    }
    fun sum(r1: Int, c1: Int, r2: Int, c2: Int): Long =
        p[r2 + 1][c2 + 1] - p[r1][c2 + 1] - p[r2 + 1][c1] + p[r1][c1]
}
```

Use case: "how many taps landed in this region of the screen?" for an on-device heatmap, answered in O(1) per region.

---

## Common mistakes

1. **No leading zero.** Without `prefix[0] = 0`, every range starting at index 0 needs a special case and usually gets a bug.
2. **Integer overflow.** Sums of `Int` values overflow quickly. Use `Long` in Kotlin and Swift on 32-bit targets. In TypeScript, stay below 2^53.
3. **Forgetting the `{0: 1}` seed** in the hash map version, which drops subarrays starting at index 0.
4. **Inserting before looking up** in "count sum = k", which breaks `k == 0`.
5. **Using a prefix array on data that changes often.** Each change makes rebuilding O(n). Use a Fenwick tree.
6. **Negative modulo** in "divisible by m" variants. Normalize with `((p % m) + m) % m`.
7. **Difference array without the extra slot**, so `diff[r + 1]` overflows the array when `r = n − 1`.

---

## Self-Check

**15.1** Why is the prefix array length `n + 1`, and what does `prefix[i]` mean?

**15.2** Write the formula for `sum(a[l..r])` using the prefix array.

**15.3** Why does "count subarrays with sum k" need a hash map rather than a sliding window when values can be negative?

**15.4** You get 10,000 "add v to range [l..r]" updates and then read the final array once. What structure do you use, and what does it cost?

**15.5** When should you use a Fenwick tree instead of a plain prefix array?

*(Answers: Appendix D.)*

---

## Practice

1. **Find pivot index** — the first index where the sum of everything to its left equals the sum of everything to its right (balance point on a timeline). [solutions/ch15](../../solutions/ch15/README.md#p1-find-pivot-index)
2. **Contiguous array (equal 0s and 1s)** — the longest subarray with as many 0s as 1s (balanced up- and down-votes). [solutions/ch15](../../solutions/ch15/README.md#p2-contiguous-array-equal-0s-and-1s)
3. **Car pooling (capacity check)** — trips `[passengers, from, to]` along a route. Can a vehicle with `capacity` seats serve them all? [solutions/ch15](../../solutions/ch15/README.md#p3-car-pooling-capacity-check)

### More practice

- [Ch 29 — Interview Questions, Q1–Q10](../part-viii/29-interview-questions-q01-q10.md): Q5 Subarray Sum Equals K
- [Ch 31 — Arrays, Hashing & Matrix](../part-viii/31-arrays-hashing-matrix.md): Q1 Product of Array Except Self (prefix × suffix) · Q5 Maximum Subarray · Q9 Range Sum Query — Immutable
- [Ch 36 — Graphs & Dynamic Programming](../part-viii/36-graphs-dynamic-programming.md): Q14 Target Sum (a prefix-style DP)

---

## What to remember

Prefix sums move range queries from O(n) to O(1) by paying O(n) once. Always use a leading zero. Difference arrays do the same for range updates. A prefix value plus a hash map handles "subarray with sum k" when negative numbers rule out a window. Keep sums in 64-bit integers, and for money in minor units. If the data changes often, use a Fenwick tree instead of rebuilding.

---

Previous: [Chapter 14 — Sliding Window](14-sliding-window.md) · Next: [Chapter 16 — Monotonic Stack & Deque](16-monotonic-stack-deque.md) · Solutions: [`solutions/ch15`](../../solutions/ch15/README.md)
