# Chapter 34 — Solution Index & Extra Ports

Full **Kotlin + TypeScript** solutions live inline in [`book/part-x/34-stacks-binary-search.md`](../../book/part-x/34-stacks-binary-search.md). The chapter now shows all four languages inline; this file adds a timed-review index and repeats the **Swift/Dart** ports for three of the most interview-heavy problems.

| # | Title | Topic | One-line approach |
|---|-------|-------|-------------------|
| [Q1](../../book/part-x/34-stacks-binary-search.md#q1-evaluate-reverse-polish-notation-calculator-keypad-engine) | Evaluate Reverse Polish Notation | Stack | Push numbers; operator pops b, a and pushes a op b |
| [Q2](../../book/part-x/34-stacks-binary-search.md#q2-daily-temperatures-warmer-day-countdown) | Daily Temperatures | Monotonic stack | Stack of unresolved indices, temps decreasing; pop when warmer |
| [Q3](../../book/part-x/34-stacks-binary-search.md#q3-largest-rectangle-in-histogram-biggest-banner-in-a-bar-chart) | Largest Rectangle in Histogram | Monotonic stack | Increasing stack + 0 sentinel; popped bar spans (left, i) |
| [Q4](../../book/part-x/34-stacks-binary-search.md#q4-find-minimum-in-rotated-sorted-array-oldest-slot-in-a-ring-buffer) | Find Minimum in Rotated Sorted Array | Binary search | Compare mid with hi; drop is right if nums[mid] > nums[hi] |
| [Q5](../../book/part-x/34-stacks-binary-search.md#q5-search-in-rotated-sorted-array-lookup-in-a-wrapped-log) | Search in Rotated Sorted Array | Binary search | One half is always sorted; test target against it |
| [Q6](../../book/part-x/34-stacks-binary-search.md#q6-search-in-rotated-sorted-array-ii-duplicates-allowed) | Search in Rotated Sorted Array II | Binary search | Same as Q5, but shrink both ends when lo = mid = hi |
| [Q7](../../book/part-x/34-stacks-binary-search.md#q7-search-a-2d-matrix-paged-sorted-catalogue) | Search a 2D Matrix | Binary search | Binary search a virtual array; k → (k / n, k % n) |
| [Q8](../../book/part-x/34-stacks-binary-search.md#q8-koko-eating-bananas-minimum-upload-rate) | Koko Eating Bananas | Binary search on the answer | Binary-search k in [1, max]; hours = Σ ceil(p / k) |
| [Q9](../../book/part-x/34-stacks-binary-search.md#q9-time-based-key-value-store-versioned-config-cache) | Time Based Key-Value Store | Hash map + binary search | Key → time-sorted list; floor binary search on get |

---

Dart snippets use `max` from `dart:math` (`import 'dart:math';`).

---

## Q3 — Largest rectangle in histogram (Swift / Dart)

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

---

## Q5 — Search in rotated sorted array (Swift / Dart)

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

---

## Q8 — Koko eating bananas (Swift / Dart)

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

---

Back to the chapter: [Chapter 34](../../book/part-x/34-stacks-binary-search.md)
