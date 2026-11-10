# Chapter 34 — Stacks & Binary Search (12-Day Plan Gap-Closer)

Part X fills the gaps between the book and the public **12-day DSA plan** (120 standard LeetCode problems). This chapter covers the plan's stack and binary-search problems that the book did not have yet. The plan problems already in the book stay where they are: [Valid Parentheses (Ch 24 Q6)](../part-vii/24-interview-questions.md#q6-valid-parentheses-schema-deep-link-path), [Min Stack (Ch 24 Q7)](../part-vii/24-interview-questions.md#q7-min-stack-debug-overlay) and [Binary Search (Ch 24 Q18)](../part-vii/24-interview-questions.md#q18-binary-search) in the Chapter 24 question bank (topic background in [Chapter 05](../part-ii/05-stacks.md) and [Chapter 15](../part-v/15-searching-sorting.md)), and Median of Two Sorted Arrays in the [Chapter 27 hard bank](../part-viii/27-hard-drill-bank.md). Linked-list and tree gaps are in [Chapter 35](35-linked-lists-trees.md).

Companion index: [`solutions/ch34/README.md`](../../solutions/ch34/README.md)

---

## How to use

| Protocol | Detail |
|----------|--------|
| **Time** | 20–30 minutes per problem (mostly mediums; Q3 is a hard) |
| **Speak first** | Brute force in one sentence, then the optimal idea and **time/space before code** |
| **Languages** | Every entry shows **Kotlin, Swift, Dart, TypeScript** in that order (Android/KMP, iOS, Flutter, React Native). Dart snippets that call `max` need `import 'dart:math';` |
| **Mobile tell** | One sentence where it helps: main-thread cost, memory bound, or the UI tree it maps to |
| **Plan Day 2** | Q4 Find Minimum in Rotated Sorted Array, Q7 Search a 2D Matrix |
| **Plan Day 5** | Q1 Evaluate RPN, Q2 Daily Temperatures, Q3 Largest Rectangle in Histogram, Q5 Search in Rotated Sorted Array, Q8 Koko Eating Bananas, Q9 Time Based Key-Value Store (Q7 repeats here) |
| **Plan Day 6** | Q6 Search in Rotated Sorted Array II (Q4 repeats here) |

**Order to drill:** Q2 → Q3 (same monotonic stack, harder bookkeeping), then Q4 → Q5 → Q6 (each adds one branch to the same loop), then Q8 (binary search on the answer).

---

## Q1. Evaluate Reverse Polish Notation (Calculator Keypad Engine)

**Topic:** Stack

**Plan day:** Day 5

**Statement**

A calculator screen has already converted the user's input into postfix tokens (numbers and the operators `+ - * /`), e.g. `["2", "1", "+", "3", "*"]` means `(2 + 1) * 3`. Return the integer result. Division truncates toward zero; the expression is always valid.

**Approach**

Brute force: rebuild an infix string and re-parse it with precedence rules, which is longer and slower. Optimal: one stack. Push numbers; on an operator pop `b` then `a` (order matters for `-` and `/`) and push `a op b`. The last value left is the answer.

**Complexity:** Time O(n), Space O(n)

### Kotlin

```kotlin
fun evalRPN(tokens: Array<String>): Int {
    val stack = ArrayDeque<Int>()
    for (t in tokens) {
        if (t == "+" || t == "-" || t == "*" || t == "/") {
            val b = stack.removeLast()
            val a = stack.removeLast()
            stack.addLast(
                when (t) {
                    "+" -> a + b
                    "-" -> a - b
                    "*" -> a * b
                    else -> a / b // Kotlin Int division truncates toward zero
                }
            )
        } else {
            stack.addLast(t.toInt())
        }
    }
    return stack.removeLast()
}
```

### Swift

```swift
func evalRPN(_ tokens: [String]) -> Int {
    var stack: [Int] = []
    for t in tokens {
        if t == "+" || t == "-" || t == "*" || t == "/" {
            let b = stack.removeLast()
            let a = stack.removeLast()
            switch t {
            case "+": stack.append(a + b)
            case "-": stack.append(a - b)
            case "*": stack.append(a * b)
            default: stack.append(a / b) // Swift Int division truncates toward zero
            }
        } else {
            stack.append(Int(t) ?? 0)
        }
    }
    return stack.removeLast()
}
```

### Dart

```dart
int evalRPN(List<String> tokens) {
  final stack = <int>[];
  for (final t in tokens) {
    if (t == '+' || t == '-' || t == '*' || t == '/') {
      final b = stack.removeLast();
      final a = stack.removeLast();
      switch (t) {
        case '+':
          stack.add(a + b);
        case '-':
          stack.add(a - b);
        case '*':
          stack.add(a * b);
        default:
          stack.add(a ~/ b); // ~/ truncates toward zero
      }
    } else {
      stack.add(int.parse(t));
    }
  }
  return stack.removeLast();
}
```

### TypeScript

```typescript
function evalRPN(tokens: string[]): number {
  const stack: number[] = [];
  for (const t of tokens) {
    if (t === "+" || t === "-" || t === "*" || t === "/") {
      const b = stack.pop()!;
      const a = stack.pop()!;
      if (t === "+") stack.push(a + b);
      else if (t === "-") stack.push(a - b);
      else if (t === "*") stack.push(a * b);
      else stack.push(Math.trunc(a / b)); // truncate toward zero
    } else {
      stack.push(Number(t));
    }
  }
  return stack.pop()!;
}
```

**Mobile note:** Postfix needs no precedence or parentheses at evaluation time, which is why calculator apps convert once (shunting-yard) and then evaluate on every keystroke cheaply.

---

## Q2. Daily Temperatures (Warmer-Day Countdown)

**Topic:** Monotonic stack

**Plan day:** Day 5

**Statement**

A weather widget has the forecast high for each of the next `n` days. For every day, return how many days until a strictly warmer day arrives, or `0` if none does.

**Approach**

Brute force: for each day scan forward until something warmer appears, O(n²). Optimal: keep a stack of indices whose answer is still unknown, with temperatures decreasing from bottom to top. Each new day pops every colder index, filling in `i - j`, then pushes itself.

**Complexity:** Time O(n) (each index is pushed and popped at most once), Space O(n)

### Kotlin

```kotlin
fun dailyTemperatures(temps: IntArray): IntArray {
    val ans = IntArray(temps.size)
    val stack = ArrayDeque<Int>() // indices, temperatures strictly decreasing
    for (i in temps.indices) {
        while (stack.isNotEmpty() && temps[stack.last()] < temps[i]) {
            val j = stack.removeLast()
            ans[j] = i - j
        }
        stack.addLast(i)
    }
    return ans
}
```

### Swift

```swift
func dailyTemperatures(_ temps: [Int]) -> [Int] {
    var ans = [Int](repeating: 0, count: temps.count)
    var stack: [Int] = [] // indices, temperatures strictly decreasing
    for i in temps.indices {
        while let j = stack.last, temps[j] < temps[i] {
            stack.removeLast()
            ans[j] = i - j
        }
        stack.append(i)
    }
    return ans
}
```

### Dart

```dart
List<int> dailyTemperatures(List<int> temps) {
  final ans = List<int>.filled(temps.length, 0);
  final stack = <int>[]; // indices, temperatures strictly decreasing
  for (var i = 0; i < temps.length; i++) {
    while (stack.isNotEmpty && temps[stack.last] < temps[i]) {
      final j = stack.removeLast();
      ans[j] = i - j;
    }
    stack.add(i);
  }
  return ans;
}
```

### TypeScript

```typescript
function dailyTemperatures(temps: number[]): number[] {
  const ans = new Array<number>(temps.length).fill(0);
  const stack: number[] = []; // indices, temperatures strictly decreasing
  for (let i = 0; i < temps.length; i++) {
    while (stack.length && temps[stack[stack.length - 1]] < temps[i]) {
      const j = stack.pop()!;
      ans[j] = i - j;
    }
    stack.push(i);
  }
  return ans;
}
```

**Mobile note:** The same next-greater-element pattern answers "how long until the price beats today's" for a price-alert badge, in a single pass over the series.

---

## Q3. Largest Rectangle in Histogram (Biggest Banner in a Bar Chart)

**Topic:** Monotonic stack

**Plan day:** Day 5

**Statement**

Bars of width 1 have heights `heights[i]`. Return the area of the largest axis-aligned rectangle that fits entirely inside the bars, e.g. the biggest banner you can lay over a usage chart without crossing any bar's top.

**Approach**

Brute force: for every pair `(i, j)` take `min(heights[i..j]) * width`, O(n²). Optimal: keep a stack of indices with increasing heights. When a shorter bar arrives, each popped bar has found its right boundary (`i`) and its left boundary is the new stack top, so its widest rectangle is `height * (i - left - 1)`. A height-0 sentinel at the end flushes the stack.

**Complexity:** Time O(n), Space O(n)

### Kotlin

```kotlin
fun largestRectangleArea(heights: IntArray): Int {
    val stack = ArrayDeque<Int>() // indices, heights increasing
    var best = 0
    for (i in 0..heights.size) {
        val h = if (i == heights.size) 0 else heights[i] // sentinel flushes the stack
        while (stack.isNotEmpty() && heights[stack.last()] >= h) {
            val height = heights[stack.removeLast()]
            val left = if (stack.isEmpty()) -1 else stack.last()
            best = maxOf(best, height * (i - left - 1))
        }
        stack.addLast(i)
    }
    return best
}
```

### Swift

```swift
func largestRectangleArea(_ heights: [Int]) -> Int {
    var stack: [Int] = [] // indices, heights increasing
    var best = 0
    for i in 0...heights.count {
        let h = i == heights.count ? 0 : heights[i] // sentinel flushes the stack
        while let top = stack.last, heights[top] >= h {
            stack.removeLast()
            let left = stack.last ?? -1
            best = max(best, heights[top] * (i - left - 1))
        }
        stack.append(i)
    }
    return best
}
```

### Dart

```dart
int largestRectangleArea(List<int> heights) {
  final stack = <int>[]; // indices, heights increasing
  var best = 0;
  for (var i = 0; i <= heights.length; i++) {
    final h = i == heights.length ? 0 : heights[i]; // sentinel flushes the stack
    while (stack.isNotEmpty && heights[stack.last] >= h) {
      final height = heights[stack.removeLast()];
      final left = stack.isEmpty ? -1 : stack.last;
      best = max(best, height * (i - left - 1));
    }
    stack.add(i);
  }
  return best;
}
```

### TypeScript

```typescript
function largestRectangleArea(heights: number[]): number {
  const stack: number[] = []; // indices, heights increasing
  let best = 0;
  for (let i = 0; i <= heights.length; i++) {
    const h = i === heights.length ? 0 : heights[i]; // sentinel flushes the stack
    while (stack.length && heights[stack[stack.length - 1]] >= h) {
      const height = heights[stack.pop()!];
      const left = stack.length ? stack[stack.length - 1] : -1;
      best = Math.max(best, height * (i - left - 1));
    }
    stack.push(i);
  }
  return best;
}
```

**Mobile note:** It is the core of "maximal rectangle" in a 0/1 grid (run it per row), which is how you would find the largest free area to place an overlay in a tile-based layout.

---

## Q4. Find Minimum in Rotated Sorted Array (Oldest Slot in a Ring Buffer)

**Topic:** Binary search

**Plan day:** Day 2 (repeated on Day 6)

**Statement**

A ring-buffer log stores strictly increasing sequence numbers, but the write head has wrapped, so the array is a sorted array rotated by an unknown amount, e.g. `[4, 5, 6, 7, 0, 1, 2]`. All values are distinct. Return the smallest value in O(log n).

**Approach**

Brute force: linear scan for the minimum, O(n). Optimal: compare `nums[mid]` with `nums[hi]`. If `nums[mid] > nums[hi]` the drop (and the minimum) is strictly right of `mid`; otherwise `mid` itself may be the minimum, so set `hi = mid`. Stop when `lo == hi`.

**Complexity:** Time O(log n), Space O(1)

### Kotlin

```kotlin
fun findMin(nums: IntArray): Int {
    var lo = 0
    var hi = nums.lastIndex
    while (lo < hi) {
        val mid = lo + (hi - lo) / 2
        if (nums[mid] > nums[hi]) lo = mid + 1 // minimum is right of mid
        else hi = mid                         // mid could be the minimum
    }
    return nums[lo]
}
```

### Swift

```swift
func findMin(_ nums: [Int]) -> Int {
    var lo = 0, hi = nums.count - 1
    while lo < hi {
        let mid = lo + (hi - lo) / 2
        if nums[mid] > nums[hi] { lo = mid + 1 } // minimum is right of mid
        else { hi = mid }                        // mid could be the minimum
    }
    return nums[lo]
}
```

### Dart

```dart
int findMin(List<int> nums) {
  var lo = 0, hi = nums.length - 1;
  while (lo < hi) {
    final mid = lo + (hi - lo) ~/ 2;
    if (nums[mid] > nums[hi]) {
      lo = mid + 1; // minimum is right of mid
    } else {
      hi = mid; // mid could be the minimum
    }
  }
  return nums[lo];
}
```

### TypeScript

```typescript
function findMin(nums: number[]): number {
  let lo = 0, hi = nums.length - 1;
  while (lo < hi) {
    const mid = (lo + hi) >> 1;
    if (nums[mid] > nums[hi]) lo = mid + 1; // minimum is right of mid
    else hi = mid;                          // mid could be the minimum
  }
  return nums[lo];
}
```

---

## Q5. Search in Rotated Sorted Array (Lookup in a Wrapped Log)

**Topic:** Binary search

**Plan day:** Day 5

**Statement**

Given the same kind of rotated array of distinct values and a `target`, return the index of `target`, or `-1` if it is not present, in O(log n).

**Approach**

Brute force: `indexOf`, O(n). Optimal: at every step at least one half around `mid` is sorted. If `nums[lo] <= nums[mid]` the left half is sorted, so check whether `target` lies in `[nums[lo], nums[mid])` and discard the other half; otherwise the right half is sorted and you test `(nums[mid], nums[hi]]`.

**Complexity:** Time O(log n), Space O(1)

### Kotlin

```kotlin
fun searchRotated(nums: IntArray, target: Int): Int {
    var lo = 0
    var hi = nums.lastIndex
    while (lo <= hi) {
        val mid = lo + (hi - lo) / 2
        if (nums[mid] == target) return mid
        if (nums[lo] <= nums[mid]) { // left half is sorted
            if (target >= nums[lo] && target < nums[mid]) hi = mid - 1 else lo = mid + 1
        } else {                     // right half is sorted
            if (target > nums[mid] && target <= nums[hi]) lo = mid + 1 else hi = mid - 1
        }
    }
    return -1
}
```

### Swift

```swift
func searchRotated(_ nums: [Int], _ target: Int) -> Int {
    var lo = 0, hi = nums.count - 1
    while lo <= hi {
        let mid = lo + (hi - lo) / 2
        if nums[mid] == target { return mid }
        if nums[lo] <= nums[mid] { // left half is sorted
            if target >= nums[lo] && target < nums[mid] { hi = mid - 1 } else { lo = mid + 1 }
        } else {                   // right half is sorted
            if target > nums[mid] && target <= nums[hi] { lo = mid + 1 } else { hi = mid - 1 }
        }
    }
    return -1
}
```

### Dart

```dart
int searchRotated(List<int> nums, int target) {
  var lo = 0, hi = nums.length - 1;
  while (lo <= hi) {
    final mid = lo + (hi - lo) ~/ 2;
    if (nums[mid] == target) return mid;
    if (nums[lo] <= nums[mid]) { // left half is sorted
      if (target >= nums[lo] && target < nums[mid]) { hi = mid - 1; } else { lo = mid + 1; }
    } else {                     // right half is sorted
      if (target > nums[mid] && target <= nums[hi]) { lo = mid + 1; } else { hi = mid - 1; }
    }
  }
  return -1;
}
```

### TypeScript

```typescript
function searchRotated(nums: number[], target: number): number {
  let lo = 0, hi = nums.length - 1;
  while (lo <= hi) {
    const mid = (lo + hi) >> 1;
    if (nums[mid] === target) return mid;
    if (nums[lo] <= nums[mid]) { // left half is sorted
      if (target >= nums[lo] && target < nums[mid]) hi = mid - 1; else lo = mid + 1;
    } else {                     // right half is sorted
      if (target > nums[mid] && target <= nums[hi]) lo = mid + 1; else hi = mid - 1;
    }
  }
  return -1;
}
```

---

## Q6. Search in Rotated Sorted Array II (Duplicates Allowed)

**Topic:** Binary search

**Plan day:** Day 6

**Statement**

Same as the previous problem, but the array may contain duplicates (several log entries can share a sequence bucket). Return `true` if `target` is present.

**Approach**

Brute force: linear scan, O(n). Optimal: reuse the sorted-half test, but when `nums[lo] == nums[mid] == nums[hi]` you cannot tell which half is sorted, so shrink both ends by one and continue. That one extra branch is the whole difference.

**Complexity:** Time O(log n) average, O(n) worst case (e.g. `[1, 1, 1, 0, 1]`), Space O(1)

### Kotlin

```kotlin
fun searchRotatedWithDups(nums: IntArray, target: Int): Boolean {
    var lo = 0
    var hi = nums.lastIndex
    while (lo <= hi) {
        val mid = lo + (hi - lo) / 2
        if (nums[mid] == target) return true
        if (nums[lo] == nums[mid] && nums[mid] == nums[hi]) { // can't tell which half is sorted
            lo++
            hi--
        } else if (nums[lo] <= nums[mid]) {
            if (target >= nums[lo] && target < nums[mid]) hi = mid - 1 else lo = mid + 1
        } else {
            if (target > nums[mid] && target <= nums[hi]) lo = mid + 1 else hi = mid - 1
        }
    }
    return false
}
```

### Swift

```swift
func searchRotatedWithDups(_ nums: [Int], _ target: Int) -> Bool {
    var lo = 0, hi = nums.count - 1
    while lo <= hi {
        let mid = lo + (hi - lo) / 2
        if nums[mid] == target { return true }
        if nums[lo] == nums[mid] && nums[mid] == nums[hi] { // can't tell which half is sorted
            lo += 1
            hi -= 1
        } else if nums[lo] <= nums[mid] {
            if target >= nums[lo] && target < nums[mid] { hi = mid - 1 } else { lo = mid + 1 }
        } else {
            if target > nums[mid] && target <= nums[hi] { lo = mid + 1 } else { hi = mid - 1 }
        }
    }
    return false
}
```

### Dart

```dart
bool searchRotatedWithDups(List<int> nums, int target) {
  var lo = 0, hi = nums.length - 1;
  while (lo <= hi) {
    final mid = lo + (hi - lo) ~/ 2;
    if (nums[mid] == target) return true;
    if (nums[lo] == nums[mid] && nums[mid] == nums[hi]) { // can't tell which half is sorted
      lo++;
      hi--;
    } else if (nums[lo] <= nums[mid]) {
      if (target >= nums[lo] && target < nums[mid]) { hi = mid - 1; } else { lo = mid + 1; }
    } else {
      if (target > nums[mid] && target <= nums[hi]) { lo = mid + 1; } else { hi = mid - 1; }
    }
  }
  return false;
}
```

### TypeScript

```typescript
function searchRotatedWithDups(nums: number[], target: number): boolean {
  let lo = 0, hi = nums.length - 1;
  while (lo <= hi) {
    const mid = (lo + hi) >> 1;
    if (nums[mid] === target) return true;
    if (nums[lo] === nums[mid] && nums[mid] === nums[hi]) { // can't tell which half is sorted
      lo++;
      hi--;
    } else if (nums[lo] <= nums[mid]) {
      if (target >= nums[lo] && target < nums[mid]) hi = mid - 1; else lo = mid + 1;
    } else {
      if (target > nums[mid] && target <= nums[hi]) lo = mid + 1; else hi = mid - 1;
    }
  }
  return false;
}
```

---

## Q7. Search a 2D Matrix (Paged Sorted Catalogue)

**Topic:** Binary search

**Plan day:** Day 2 (repeated on Day 5)

**Statement**

A catalogue is cached as `m` pages of `n` sorted IDs each, and every page starts after the previous page ends, so reading row by row gives one sorted sequence. Return whether `target` exists, in O(log(m·n)).

**Approach**

Brute force: scan every cell, O(m·n), or binary search each row, O(m log n). Optimal: treat the grid as one virtual sorted array of length `m·n`; index `k` maps to `matrix[k / n][k % n]`, so a single binary search is enough.

**Complexity:** Time O(log(m·n)), Space O(1)

### Kotlin

```kotlin
fun searchMatrix(matrix: Array<IntArray>, target: Int): Boolean {
    if (matrix.isEmpty() || matrix[0].isEmpty()) return false
    val cols = matrix[0].size
    var lo = 0
    var hi = matrix.size * cols - 1
    while (lo <= hi) {
        val mid = lo + (hi - lo) / 2
        val v = matrix[mid / cols][mid % cols] // treat the grid as one sorted array
        when {
            v == target -> return true
            v < target -> lo = mid + 1
            else -> hi = mid - 1
        }
    }
    return false
}
```

### Swift

```swift
func searchMatrix(_ matrix: [[Int]], _ target: Int) -> Bool {
    guard let first = matrix.first, !first.isEmpty else { return false }
    let cols = first.count
    var lo = 0, hi = matrix.count * cols - 1
    while lo <= hi {
        let mid = lo + (hi - lo) / 2
        let v = matrix[mid / cols][mid % cols] // treat the grid as one sorted array
        if v == target { return true }
        if v < target { lo = mid + 1 } else { hi = mid - 1 }
    }
    return false
}
```

### Dart

```dart
bool searchMatrix(List<List<int>> matrix, int target) {
  if (matrix.isEmpty || matrix[0].isEmpty) return false;
  final cols = matrix[0].length;
  var lo = 0, hi = matrix.length * cols - 1;
  while (lo <= hi) {
    final mid = lo + (hi - lo) ~/ 2;
    final v = matrix[mid ~/ cols][mid % cols]; // treat the grid as one sorted array
    if (v == target) return true;
    if (v < target) {
      lo = mid + 1;
    } else {
      hi = mid - 1;
    }
  }
  return false;
}
```

### TypeScript

```typescript
function searchMatrix(matrix: number[][], target: number): boolean {
  if (matrix.length === 0 || matrix[0].length === 0) return false;
  const cols = matrix[0].length;
  let lo = 0, hi = matrix.length * cols - 1;
  while (lo <= hi) {
    const mid = (lo + hi) >> 1;
    const v = matrix[Math.floor(mid / cols)][mid % cols]; // grid as one sorted array
    if (v === target) return true;
    if (v < target) lo = mid + 1;
    else hi = mid - 1;
  }
  return false;
}
```

---

## Q8. Koko Eating Bananas (Minimum Upload Rate)

**Topic:** Binary search on the answer

**Plan day:** Day 5

**Statement**

An offline queue holds `piles[i]` items per batch. Each hour the uploader picks one batch and sends up to `k` items from it (if the batch has fewer, the rest of that hour is idle). Return the smallest integer rate `k` that drains every batch within `h` hours (`h >= piles.size`).

**Approach**

Brute force: try `k = 1, 2, 3, ...` until the hours fit, O(max · n). Optimal: the hours needed, `sum(ceil(p / k))`, only goes down as `k` goes up, so binary-search `k` in `[1, max(piles)]` for the first feasible rate.

**Complexity:** Time O(n log max), Space O(1)

### Kotlin

```kotlin
fun minEatingSpeed(piles: IntArray, h: Int): Int {
    var lo = 1
    var hi = piles.max()
    while (lo < hi) {
        val k = lo + (hi - lo) / 2
        var hours = 0L
        for (p in piles) hours += (p - 1) / k + 1  // ceil(p / k), overflow-safe
        if (hours <= h) hi = k else lo = k + 1    // feasible: try slower
    }
    return lo
}
```

### Swift

```swift
func minEatingSpeed(_ piles: [Int], _ h: Int) -> Int {
    var lo = 1, hi = piles.max() ?? 1
    while lo < hi {
        let k = lo + (hi - lo) / 2
        let hours = piles.reduce(0) { $0 + ($1 - 1) / k + 1 } // sum of ceil(p / k)
        if hours <= h { hi = k } else { lo = k + 1 }
    }
    return lo
}
```

### Dart

```dart
int minEatingSpeed(List<int> piles, int h) {
  var lo = 1, hi = piles.reduce(max);
  while (lo < hi) {
    final k = lo + (hi - lo) ~/ 2;
    final hours = piles.fold<int>(0, (s, p) => s + (p - 1) ~/ k + 1); // sum of ceil(p / k)
    if (hours <= h) { hi = k; } else { lo = k + 1; }
  }
  return lo;
}
```

### TypeScript

```typescript
function minEatingSpeed(piles: number[], h: number): number {
  let lo = 1, hi = Math.max(...piles);
  while (lo < hi) {
    const k = Math.floor((lo + hi) / 2);
    let hours = 0;
    for (const p of piles) hours += Math.ceil(p / k);
    if (hours <= h) hi = k; // feasible: try slower
    else lo = k + 1;
  }
  return lo;
}
```

**Mobile note:** This "guess the answer, check feasibility" shape fits capacity questions such as the smallest batch size or bitrate that finishes a sync within a background-task window.

---

## Q9. Time Based Key-Value Store (Versioned Config Cache)

**Topic:** Hash map + binary search

**Plan day:** Day 5

**Statement**

Design `TimeMap` with `set(key, value, timestamp)` and `get(key, timestamp)`. `get` returns the value stored at the largest timestamp `<= timestamp`, or `""` if none exists. For any one key, `set` is called with strictly increasing timestamps (like remote-config versions arriving over time).

**Approach**

Brute force: keep every `(time, value)` pair and scan backwards on `get`, O(n) per read. Optimal: map each key to a list that stays sorted because timestamps arrive in order; `set` appends in O(1) and `get` binary-searches for the last entry with time `<= timestamp`.

**Complexity:** `set` O(1), `get` O(log n) per key, Space O(total entries)

### Kotlin

```kotlin
class TimeMap {
    private val store = HashMap<String, MutableList<Pair<Int, String>>>()

    // Timestamps for a key arrive in increasing order, so each list stays sorted.
    fun set(key: String, value: String, timestamp: Int) {
        store.getOrPut(key) { mutableListOf() }.add(timestamp to value)
    }

    fun get(key: String, timestamp: Int): String {
        val list = store[key] ?: return ""
        var lo = 0
        var hi = list.lastIndex
        var ans = ""
        while (lo <= hi) { // last entry with time <= timestamp
            val mid = lo + (hi - lo) / 2
            if (list[mid].first <= timestamp) {
                ans = list[mid].second
                lo = mid + 1
            } else {
                hi = mid - 1
            }
        }
        return ans
    }
}
```

### Swift

```swift
final class TimeMap {
    private var store: [String: [(time: Int, value: String)]] = [:]

    // Timestamps for a key arrive in increasing order, so each list stays sorted.
    func set(_ key: String, _ value: String, _ timestamp: Int) {
        store[key, default: []].append((timestamp, value))
    }

    func get(_ key: String, _ timestamp: Int) -> String {
        guard let list = store[key] else { return "" }
        var lo = 0, hi = list.count - 1
        var ans = ""
        while lo <= hi { // last entry with time <= timestamp
            let mid = lo + (hi - lo) / 2
            if list[mid].time <= timestamp {
                ans = list[mid].value
                lo = mid + 1
            } else {
                hi = mid - 1
            }
        }
        return ans
    }
}
```

### Dart

```dart
class TimeMap {
  final _store = <String, List<(int, String)>>{};

  // Timestamps for a key arrive in increasing order, so each list stays sorted.
  void set(String key, String value, int timestamp) {
    _store.putIfAbsent(key, () => []).add((timestamp, value));
  }

  String get(String key, int timestamp) {
    final list = _store[key];
    if (list == null) return '';
    var lo = 0, hi = list.length - 1;
    var ans = '';
    while (lo <= hi) { // last entry with time <= timestamp
      final mid = lo + (hi - lo) ~/ 2;
      if (list[mid].$1 <= timestamp) {
        ans = list[mid].$2;
        lo = mid + 1;
      } else {
        hi = mid - 1;
      }
    }
    return ans;
  }
}
```

### TypeScript

```typescript
class TimeMap {
  private store = new Map<string, [number, string][]>();

  // Timestamps for a key arrive in increasing order, so each list stays sorted.
  set(key: string, value: string, timestamp: number): void {
    let list = this.store.get(key);
    if (!list) { list = []; this.store.set(key, list); }
    list.push([timestamp, value]);
  }

  get(key: string, timestamp: number): string {
    const list = this.store.get(key);
    if (!list) return "";
    let lo = 0, hi = list.length - 1, ans = "";
    while (lo <= hi) { // last entry with time <= timestamp
      const mid = (lo + hi) >> 1;
      if (list[mid][0] <= timestamp) { ans = list[mid][1]; lo = mid + 1; }
      else hi = mid - 1;
    }
    return ans;
  }
}
```

**Mobile note:** This is the read path for "what was the config or FX rate at the time this payment was created": keep the history append-only and answer point-in-time reads with a floor search.

---

## Drill checklist (say aloud)

1. Brute force in one sentence, then the optimal idea.  
2. Complexity **before** code.  
3. Name the invariant (what the stack holds, which half is sorted, what the DFS returns).  
4. Edges: empty input, single element, duplicates, `k` or `n` at the boundary.  
5. One mobile sentence if it is genuinely relevant.

Previous: [Chapter 33 — Two Pointers, Sliding Window & Intervals](33-two-pointers-windows-intervals.md) · Next: [Chapter 35 — Linked Lists & Trees](35-linked-lists-trees.md) · Related: [Chapter 24 — Interview Questions](../part-vii/24-interview-questions.md) · [Chapter 27 — Hard Drill Bank](../part-viii/27-hard-drill-bank.md)
