# Chapter 14 — Sliding Window

A sliding window is two pointers that bound a **contiguous** range: `left` and `right` mark the current subarray or substring. As `right` moves forward, you update a running summary (sum, counts, distinct keys) in O(1) instead of recomputing it. Every "best contiguous stretch" problem with an O(n·k) or O(n²) brute force has an O(n) window version, as long as the window can be updated incrementally.

---

## Mobile motivation

- **Jank triage:** given per-frame render times, find the worst 30-frame stretch, which is the half-second the user actually felt.
- **Data budget:** a prefetch queue lists image sizes in scroll order. What is the longest run of consecutive images that fits in a 5MB burst?
- **Session analytics:** find the longest scroll session that touched at most two content categories, computed on device so no raw event stream has to be uploaded.
- **Rate limiting:** "no more than N requests in any 60-second window" is a window over timestamps. The token bucket in [Ch 29 Q38](../part-viii/29-interview-questions-q31-q40.md) and the hit counter in [Ch 30 Q19](../part-viii/30-hard-drill-bank-q11-q20.md) both use this idea.

---

## Two kinds of window

| Kind | Window size | Loop shape | Examples |
|------|-------------|------------|----------|
| **Fixed** | Always `k` | Add `a[right]`, remove `a[right - k]` once the window is full | Max sum of k items, average of last k frames, anagram positions |
| **Variable** | Grows and shrinks | Expand `right` every step. **While** the window breaks the rule, shrink `left`. Then record the answer | Longest run within budget, longest substring without repeats, smallest subarray with sum ≥ target |

### Variable-window template

```text
left = 0
state = empty
for right in 0 until n:
    add a[right] to state
    while state is invalid:
        remove a[left] from state
        left++
    answer = best(answer, right - left + 1)   // window [left..right] is valid here
```

For a **"smallest window that satisfies"** problem, flip it: shrink *while the window is valid*, recording the answer inside the `while` loop.

### Why it is O(n)

`right` moves forward n times. `left` also only ever moves forward, so across the whole run it moves at most n times. The inner `while` costs O(n) **in total**, not per step. Say this out loud in interviews, because the nested loop makes people think the code is O(n²).

### When the window does NOT work

The shrink step assumes that making the window smaller never breaks the rule more. With **negative numbers**, "sum ≤ budget" loses that property: shrinking can increase the sum. For subarray sums with negatives, use prefix sums plus a hash map (Chapter 15).

---

## Complexity at a glance

| Problem | Brute force | Window | Extra space |
|---------|-------------|--------|-------------|
| Max sum of k consecutive | O(n·k) | O(n) | O(1) |
| Longest run with sum ≤ B (non-negative) | O(n²) | O(n) | O(1) |
| Longest substring, ≤ k distinct chars | O(n²) | O(n) | O(k) map |
| Longest substring without repeats | O(n²)–O(n³) | O(n) | O(alphabet) |
| Minimum window containing all of `t` | O(n²·m) | O(n + m) | O(alphabet) |

---

## How to recognize it

1. The answer is a **contiguous** subarray or substring.
2. You want the **longest / shortest / count / max sum** of such a stretch.
3. The rule can be checked from a running summary, and the summary can be updated when an element **enters and leaves**.
4. For variable windows, the rule must be **monotonic**: if a window is valid, every smaller window inside it is valid too (or the reverse for "at least" rules).

If the elements can be **reordered** or don't need to be next to each other, it isn't a window problem.

---

## Platform bridges

| Platform | Where windows show up |
|----------|-----------------------|
| **Android** | Frame metrics (`JankStats`, `FrameMetricsAggregator`) give per-frame durations: a fixed window finds the worst stretch. Coroutine flows can do rolling windows with `windowed(k)` (allocates per window), so prefer a manual running sum in hot code. |
| **iOS** | `MetricKit` hitch rates are already windowed. For live overlays, keep a ring buffer (Chapter 6) plus a running sum. `swift-algorithms` `windows(ofCount:)` is a view, not a running aggregate. |
| **Flutter** | `FrameTiming` callbacks report build/raster durations. A fixed window over the last 120 frames drives a debug jank meter. |
| **React Native** | Rolling averages for scroll velocity or FPS monitors. Keep a numeric ring and a sum, not `array.slice(-k).reduce(...)` on every frame. |

---

## Worked example 1: worst k-frame stretch (fixed window)

Return the largest sum of any `k` consecutive frame durations (ms). Assume `1 ≤ k ≤ n`.

### Kotlin

```kotlin
fun maxWindowSum(frames: IntArray, k: Int): Int {
    var sum = 0
    for (i in 0 until k) sum += frames[i]
    var best = sum
    for (right in k until frames.size) {
        sum += frames[right] - frames[right - k]   // slide: add new, drop oldest
        if (sum > best) best = sum
    }
    return best
}
```

### Swift

```swift
func maxWindowSum(_ frames: [Int], _ k: Int) -> Int {
    var sum = frames[0..<k].reduce(0, +)
    var best = sum
    for right in k..<frames.count {
        sum += frames[right] - frames[right - k]
        best = max(best, sum)
    }
    return best
}
```

### Dart

```dart
int maxWindowSum(List<int> frames, int k) {
  var sum = 0;
  for (var i = 0; i < k; i++) {
    sum += frames[i];
  }
  var best = sum;
  for (var right = k; right < frames.length; right++) {
    sum += frames[right] - frames[right - k];
    if (sum > best) best = sum;
  }
  return best;
}
```

### TypeScript

```typescript
function maxWindowSum(frames: number[], k: number): number {
  let sum = 0;
  for (let i = 0; i < k; i++) sum += frames[i];
  let best = sum;
  for (let right = k; right < frames.length; right++) {
    sum += frames[right] - frames[right - k];
    best = Math.max(best, sum);
  }
  return best;
}
```

**Complexity:** O(n) time, O(1) space. **Mobile note:** in a live overlay, feed frames into a ring buffer of size k and keep `sum` up to date on each insert. You never rescan.

---

## Worked example 2: longest prefetch run within a byte budget (variable window)

Sizes are non-negative. Return the length of the longest contiguous run whose total is ≤ `budget`.

### Kotlin

```kotlin
fun longestWithinBudget(sizes: IntArray, budget: Int): Int {
    var left = 0
    var sum = 0L
    var best = 0
    for (right in sizes.indices) {
        sum += sizes[right]
        while (sum > budget) {          // shrink until valid again
            sum -= sizes[left]
            left++
        }
        best = maxOf(best, right - left + 1)
    }
    return best
}
```

### Swift

```swift
func longestWithinBudget(_ sizes: [Int], _ budget: Int) -> Int {
    var left = 0, sum = 0, best = 0
    for right in sizes.indices {
        sum += sizes[right]
        while sum > budget {
            sum -= sizes[left]
            left += 1
        }
        best = max(best, right - left + 1)
    }
    return best
}
```

### Dart

```dart
int longestWithinBudget(List<int> sizes, int budget) {
  var left = 0, sum = 0, best = 0;
  for (var right = 0; right < sizes.length; right++) {
    sum += sizes[right];
    while (sum > budget) {
      sum -= sizes[left];
      left++;
    }
    if (right - left + 1 > best) best = right - left + 1;
  }
  return best;
}
```

### TypeScript

```typescript
function longestWithinBudget(sizes: number[], budget: number): number {
  let left = 0;
  let sum = 0;
  let best = 0;
  for (let right = 0; right < sizes.length; right++) {
    sum += sizes[right];
    while (sum > budget) {
      sum -= sizes[left];
      left++;
    }
    best = Math.max(best, right - left + 1);
  }
  return best;
}
```

**Complexity:** O(n) time (amortized, since `left` only moves forward), O(1) space. If a single item is larger than the budget, the window shrinks to empty (`left = right + 1`) and the length recorded is 0. **Mobile note:** Kotlin uses a `Long` sum, because byte totals overflow `Int` (2 GB) sooner than you'd expect when you sum a long feed.

---

## Windows with a frequency map

When the rule is about **what is inside** the window (distinct count, every required character present), keep a `Map<key, count>`:

- **Enter:** `count[x]++`. If it went 0 → 1, `distinct++`.
- **Leave:** `count[x]--`. If it went 1 → 0, `distinct--` (and remove the key, so `map.size` stays honest).

That is the engine behind "at most k distinct" (Practice 3), "longest substring without repeating characters" ([Ch 29 Q33](../part-viii/29-interview-questions-q31-q40.md)) and "minimum window substring" ([Ch 32 Q8](../part-viii/32-two-pointers-windows-intervals.md)). For lowercase ASCII, an `IntArray(26)` is faster than a hash map and allocates nothing.

---

## Common mistakes

1. **Using a window with negative numbers** for sum constraints. Shrinking no longer helps, so switch to prefix sums (Chapter 15).
2. **Recording the answer in the wrong place.** For "longest valid", record after the shrink loop. For "shortest valid", record inside it.
3. **Recomputing the summary** (`sum(window)`, `set(window).size`) on every step. That brings the O(k) cost back.
4. **Forgetting to remove zero-count keys** from the map, so `map.size` overstates the distinct count.
5. **Fixed window off-by-one:** the element leaving is `a[right - k]`, not `a[right - k + 1]`.
6. **Allocating per window** (`slice`, `windowed`, `subList` copies) in per-frame code.

---

## Self-Check

**14.1** The inner `while` loop sits inside a `for` loop. Why is a variable sliding window still O(n)?

**14.2** Why does the "shrink while sum > budget" window break when the array has negative numbers? What do you use instead?

**14.3** For "shortest subarray with sum ≥ target" (non-negative values), where do you record the answer: inside or after the shrink loop?

**14.4** You need the longest substring with at most k distinct characters. What state do you keep, and how do you update it when a character leaves?

**14.5** A debug FPS overlay recomputes `frames.slice(-60).reduce(...)` on every frame. What is the cost, and what is the O(1) replacement?

*(Answers: Appendix D.)*

---

## Practice

1. **Maximum average subarray** — the highest average of any `k` consecutive values (average FPS over a fixed stretch). [solutions/ch14](../../solutions/ch14/README.md#p1-maximum-average-subarray)
2. **Max consecutive ones with k flips** — the longest run of 1s if you may flip at most `k` zeros (longest online streak allowing `k` dropouts). [solutions/ch14](../../solutions/ch14/README.md#p2-max-consecutive-ones-with-k-flips)
3. **Fruit into baskets (at most two kinds)** — the longest contiguous stretch with at most 2 distinct values (scroll session touching ≤ 2 categories). [solutions/ch14](../../solutions/ch14/README.md#p3-fruit-into-baskets-at-most-two-kinds)

### More practice

- [Ch 32 — Two Pointers, Windows & Intervals](../part-viii/32-two-pointers-windows-intervals.md): Q5 Best Time to Buy and Sell Stock · Q6 Longest Repeating Character Replacement · Q7 Permutation in String · Q8 Minimum Window Substring · Q9 Minimum Size Subarray Sum · Q10 Find All Anagrams
- [Ch 29 — Interview Questions, Q31–Q40](../part-viii/29-interview-questions-q31-q40.md): Q33 Longest Substring Without Repeating Characters
- [Ch 29 — Interview Questions, Q1–Q10](../part-viii/29-interview-questions-q01-q10.md): Q8 Sliding Window Maximum (window + monotonic deque, Chapter 16)
- [Ch 30 — Hard Drill Bank, Q11–Q20](../part-viii/30-hard-drill-bank-q11-q20.md): Q11 Longest Substring with At Most K Distinct · Q19 Design Hit Counter

---

## What to remember

A window is a contiguous range with a summary you update in O(1) as items enter and leave. A fixed window adds one item and drops one. A variable window always expands, shrinks while the rule is broken, then records. It is O(n) because `left` never moves back. Check that the rule is monotonic before you trust the shrink step. If negative values break that, switch to prefix sums, which is the next chapter.

---

Previous: [Chapter 13 — Two Pointers](13-two-pointers.md) · Next: [Chapter 15 — Prefix Sums & Difference Arrays](15-prefix-sums.md) · Solutions: [`solutions/ch14`](../../solutions/ch14/README.md)
