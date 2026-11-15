# Chapter 16 — Monotonic Stack & Deque

A monotonic stack is an ordinary stack (Chapter 5) with one rule: its contents stay sorted, always increasing or always decreasing. Before you push, you pop everything that breaks the order, and **the moment an item is popped is when its answer becomes known**. That turns "for each item, find the next / previous item that is bigger / smaller" from O(n²) into O(n). A monotonic **deque** (Chapter 6) adds removal from the front, which gives the max or min of a sliding window in O(1) per step.

---

## Mobile motivation

- **Price alerts:** for each day in a price chart, how many days until the price goes higher? A per-day scan forward is O(n²) over years of daily data. A monotonic stack is O(n).
- **Live "streak" badges:** a stock or crypto ticker shows "price has been ≤ today for N days". New prices arrive one at a time, so the answer must be O(1) amortized per tick, with no rescan of history.
- **Layout:** "the largest rectangle under a bar chart" (where to put a banner) and "which items are visible from the right edge" are next-smaller and next-greater questions.
- **Scroll velocity / jank peaks:** the maximum of the last k samples, updated per frame, is a monotonic deque.

---

## The pattern

| Question for each item `i` | Scan direction | Stack keeps (bottom → top) | Pop while |
|----------------------------|----------------|----------------------------|-----------|
| **Next greater** to the right | left → right | indices with **decreasing** values | `a[top] < a[i]` (then `ans[top] = i`) |
| **Next smaller** to the right | left → right | indices with **increasing** values | `a[top] > a[i]` |
| **Previous greater** to the left | left → right | decreasing values | `a[top] <= a[i]`; after popping, `top` is the answer for `i` |
| **Previous smaller** to the left | left → right | increasing values | `a[top] >= a[i]` |

Two ways to read results:

- **Answer on pop:** the item being popped has just met its *next* greater or smaller (the current `i`).
- **Answer after popping:** whatever is left on top is the *previous* greater or smaller of the current `i`.

**Push indices, not values.** Indices give you distances (`i - top`), let you look up values, and handle duplicates.

### Why it is O(n)

Each index is pushed once and popped at most once, so the total work across all inner `while` loops is ≤ n. This is the same amortized argument as the sliding window.

### Strict vs non-strict

`<` versus `<=` in the pop condition decides how **equal values** behave. For "next strictly greater", pop on `<`. For contribution counting with duplicates (Practice 3), use strict on one side and non-strict on the other, or each subarray gets counted twice.

---

## Monotonic deque: sliding window max/min

Keep indices in a deque with **decreasing values** from front to back:

1. **Pop from the back** while the back's value ≤ the new value. Those items can never be the max while the new one is in the window.
2. **Push** the new index at the back.
3. **Pop from the front** if that index has slid out of the window (`front <= i - k`).
4. The front is the window max.

Each index enters and leaves once, so the cost is O(n) total and O(1) amortized per step. The full four-language solution is in Chapter 6 and [Ch 29 Q8 — Sliding Window Maximum](../part-viii/29-interview-questions-q01-q10.md).

---

## Complexity at a glance

| Problem | Brute force | Monotonic structure | Extra space |
|---------|-------------|---------------------|-------------|
| Next greater element (all i) | O(n²) | O(n) | O(n) |
| Online span ("days ≤ today") | O(n) per tick | O(1) amortized per tick | O(n) |
| Sliding window max | O(n·k) | O(n) | O(k) |
| Largest rectangle in histogram | O(n²) | O(n) | O(n) |
| Sum of subarray minimums | O(n²) or O(n³) | O(n) | O(n) |

---

## How to recognize it

1. "For each element, find the **next / previous greater / smaller**."
2. "How many days until…", "how far back…", "span", "visible", "blocked by".
3. Ranges bounded by the nearest bigger or smaller neighbour: rectangles, water, "subarrays where `a[i]` is the minimum".
4. Max or min of a **moving window**, which is the deque version.
5. "Remove k items to make the result smallest or largest" (greedy plus a monotonic stack).

---

## Platform bridges

| Platform | Stack / deque to use |
|----------|----------------------|
| **Android (Kotlin)** | `ArrayDeque<Int>` (Kotlin stdlib) for both stack (`addLast`/`removeLast`) and deque. For hot numeric code, an `IntArray` plus a top index avoids boxing. |
| **iOS (Swift)** | `[Int]` with `append` / `popLast` as a stack. For a deque, `Deque` from swift-collections, or an array plus a head index. |
| **Flutter (Dart)** | `List<int>` with `add` / `removeLast` as a stack. `ListQueue` from `dart:collection` as a deque. |
| **React Native (TS)** | `number[]` with `push` / `pop` as a stack. For a deque, a head index into an array (`shift()` is O(n)), or `Int32Array` for fixed n. |

---

## Worked example 1: next higher price (answer on pop)

For each day, return the next price that is strictly higher, or `-1` if none comes.

### Kotlin

```kotlin
fun nextGreaterValues(prices: IntArray): IntArray {
    val ans = IntArray(prices.size) { -1 }
    val stack = ArrayDeque<Int>()               // indices; values decreasing bottom→top
    for (i in prices.indices) {
        while (stack.isNotEmpty() && prices[stack.last()] < prices[i]) {
            ans[stack.removeLast()] = prices[i] // i is the next greater for the popped index
        }
        stack.addLast(i)
    }
    return ans                                  // indices left on the stack keep -1
}
```

### Swift

```swift
func nextGreaterValues(_ prices: [Int]) -> [Int] {
    var ans = [Int](repeating: -1, count: prices.count)
    var stack: [Int] = []
    for i in prices.indices {
        while let top = stack.last, prices[top] < prices[i] {
            ans[top] = prices[i]
            stack.removeLast()
        }
        stack.append(i)
    }
    return ans
}
```

### Dart

```dart
List<int> nextGreaterValues(List<int> prices) {
  final ans = List<int>.filled(prices.length, -1);
  final stack = <int>[];
  for (var i = 0; i < prices.length; i++) {
    while (stack.isNotEmpty && prices[stack.last] < prices[i]) {
      ans[stack.removeLast()] = prices[i];
    }
    stack.add(i);
  }
  return ans;
}
```

### TypeScript

```typescript
function nextGreaterValues(prices: number[]): number[] {
  const ans = new Array<number>(prices.length).fill(-1);
  const stack: number[] = [];
  for (let i = 0; i < prices.length; i++) {
    while (stack.length > 0 && prices[stack[stack.length - 1]] < prices[i]) {
      ans[stack.pop()!] = prices[i];
    }
    stack.push(i);
  }
  return ans;
}
```

**Complexity:** O(n) time, O(n) space. To get "days until warmer" instead of the value, store `i - top` ([Ch 33 Q2 — Daily Temperatures](../part-viii/33-stacks-binary-search.md)).

---

## Worked example 2: online price span (answer after popping)

`next(price)` returns how many consecutive days, ending today, had a price ≤ today's. The stack holds `(price, span)` pairs with strictly decreasing prices. Popping a smaller-or-equal price **absorbs its span**, so no day is ever looked at twice.

### Kotlin

```kotlin
class PriceSpan {
    private val prices = ArrayDeque<Int>()
    private val spans = ArrayDeque<Int>()
    fun next(price: Int): Int {
        var span = 1
        while (prices.isNotEmpty() && prices.last() <= price) {
            prices.removeLast()
            span += spans.removeLast()
        }
        prices.addLast(price)
        spans.addLast(span)
        return span
    }
}
```

### Swift

```swift
final class PriceSpan {
    private var stack: [(price: Int, span: Int)] = []
    func next(_ price: Int) -> Int {
        var span = 1
        while let top = stack.last, top.price <= price {
            span += top.span
            stack.removeLast()
        }
        stack.append((price, span))
        return span
    }
}
```

### Dart

```dart
class PriceSpan {
  final _prices = <int>[];
  final _spans = <int>[];
  int next(int price) {
    var span = 1;
    while (_prices.isNotEmpty && _prices.last <= price) {
      _prices.removeLast();
      span += _spans.removeLast();
    }
    _prices.add(price);
    _spans.add(span);
    return span;
  }
}
```

### TypeScript

```typescript
class PriceSpan {
  private prices: number[] = [];
  private spans: number[] = [];
  next(price: number): number {
    let span = 1;
    while (this.prices.length > 0 && this.prices[this.prices.length - 1] <= price) {
      this.prices.pop();
      span += this.spans.pop()!;
    }
    this.prices.push(price);
    this.spans.push(span);
    return span;
  }
}
```

**Complexity:** O(1) amortized per call, O(n) space in the worst case (prices strictly falling). **Mobile note:** this suits a WebSocket ticker. Each tick updates the badge in constant time on the main thread, with no history scan.

---

## Common mistakes

1. **Pushing values instead of indices.** You lose distances and can't tell duplicates apart.
2. **Wrong direction of monotonicity.** For *next greater*, the stack must be *decreasing*: you pop smaller items when a bigger one arrives.
3. **Mixing `<` and `<=` without thinking.** Duplicates get counted twice, or not at all, in contribution problems.
4. **Forgetting leftovers.** Items still on the stack at the end have no next greater. Initialize the answers to `-1` (or `n`).
5. **Using `shift()` / `removeAt(0)` for the deque front** in TypeScript or Dart lists. That's O(n) per call. Use a real deque or a head index.
6. **Recomputing the window max** with `max(slice)` every frame instead of keeping a deque.

---

## Self-Check

**16.1** For "next greater element", should the stack be increasing or decreasing from bottom to top? Why?

**16.2** Why is a monotonic stack O(n) even though there's a `while` loop inside the `for` loop?

**16.3** What is the difference between reading an answer "on pop" and "after popping"? Which questions use each?

**16.4** In a sliding window maximum deque, why can you discard smaller elements at the back when a larger one arrives?

**16.5** Why should you push indices rather than values?

*(Answers: Appendix D.)*

---

## Practice

1. **Next greater element, circular** — like Worked example 1, but the array wraps around (a carousel that loops). [solutions/ch16](../../solutions/ch16/README.md#p1-next-greater-element-circular)
2. **Remove k digits** — remove `k` digits from a number string to make the smallest possible number (shrink an ID or amount to its smallest form). [solutions/ch16](../../solutions/ch16/README.md#p2-remove-k-digits)
3. **Sum of subarray minimums** — the sum of `min(sub)` over every contiguous subarray, mod 1e9+7 (worst-latency contribution across all windows). [solutions/ch16](../../solutions/ch16/README.md#p3-sum-of-subarray-minimums)

### More practice

- [Ch 33 — Stacks & Binary Search](../part-viii/33-stacks-binary-search.md): Q2 Daily Temperatures · Q3 Largest Rectangle in Histogram
- [Ch 29 — Interview Questions, Q1–Q10](../part-viii/29-interview-questions-q01-q10.md): Q7 Min Stack · Q8 Sliding Window Maximum
- [Ch 30 — Hard Drill Bank, Q1–Q10](../part-viii/30-hard-drill-bank-q01-q10.md): Q2 Trapping Rain Water (stack variant)

---

## What to remember

Keep the stack sorted by popping anything that breaks the order, and each pop tells you something final. A popped item has found its *next* greater or smaller. Whatever stays on top is the current item's *previous* greater or smaller. Push indices. It's O(n) because each index is pushed and popped once. Add removal from the front and you have a monotonic deque, which gives O(1) amortized window max/min for live metrics.

---

Previous: [Chapter 15 — Prefix Sums & Difference Arrays](15-prefix-sums.md) · Next: [Chapter 17 — Intervals & Sweep Line](17-intervals-sweep-line.md) · Solutions: [`solutions/ch16`](../../solutions/ch16/README.md)
