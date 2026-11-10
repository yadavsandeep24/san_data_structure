# Chapter 32 — Solution Index & Extra Ports

Full **Kotlin + TypeScript** solutions live inline in [`book/part-x/32-arrays-hashing-matrix.md`](../../book/part-x/32-arrays-hashing-matrix.md). All four languages (Kotlin, Swift, Dart, TypeScript) are inline in the chapter. This file adds a timed-review index and repeats the **Swift/Dart** ports for three problems.

| # | Title | Topic | One-line approach |
|---|-------|-------|-------------------|
| [Q1](../../book/part-x/32-arrays-hashing-matrix.md#q1-product-of-array-except-self-basket-price-multipliers) | Product of Array Except Self | Prefix / suffix | Left pass writes product before i; right pass multiplies product after i; no division |
| [Q2](../../book/part-x/32-arrays-hashing-matrix.md#q2-valid-sudoku-puzzle-board-check) | Valid Sudoku | Bitmasks | One pass; 9-bit mask per row, column, box `(r/3)*3 + c/3`; bit already set → invalid |
| [Q3](../../book/part-x/32-arrays-hashing-matrix.md#q3-encode-and-decode-strings-offline-queue-serialization) | Encode and Decode Strings | Length prefix | Write `len#content`; decoder reads digits to `#`, then exactly len chars |
| [Q4](../../book/part-x/32-arrays-hashing-matrix.md#q4-string-compression-run-length-log-packing) | String Compression | Read / write pointers | Read a run; write char, then count digits if run > 1; writer never passes reader |
| [Q5](../../book/part-x/32-arrays-hashing-matrix.md#q5-maximum-subarray-best-trading-streak) | Maximum Subarray | Kadane | `cur = max(x, cur + x)`; best of cur; seed with nums[0] for all-negative |
| [Q6](../../book/part-x/32-arrays-hashing-matrix.md#q6-maximum-product-subarray-compounded-multiplier-streak) | Maximum Product Subarray | Max + min DP | Track max and min ending here; new = max/min of x, max·x, min·x |
| [Q7](../../book/part-x/32-arrays-hashing-matrix.md#q7-set-matrix-zeroes-invalidate-grid-rows-and-columns) | Set Matrix Zeroes | In-place markers | Remember row 0 / col 0 zeros; mark in row 0 / col 0; clear inner; then row 0 / col 0 |
| [Q8](../../book/part-x/32-arrays-hashing-matrix.md#q8-spiral-matrix-onboarding-tile-reveal-order) | Spiral Matrix | Boundaries | Top row, right col, bottom row (if rows left), left col (if cols left); shrink each |
| [Q9](../../book/part-x/32-arrays-hashing-matrix.md#q9-range-sum-query-immutable-statement-range-totals) | Range Sum Query — Immutable | Prefix sums | `prefix[i+1] = prefix[i] + nums[i]` in Long; query `prefix[r+1] − prefix[l]` |
| [Q10](../../book/part-x/32-arrays-hashing-matrix.md#q10-first-missing-positive-next-free-ticket-number) | First Missing Positive | Index as hash | Swap v in 1..n into slot v−1; first slot i without i+1 → answer, else n+1 |

---

## Q1 — Product of array except self (Swift / Dart)

### Swift

```swift
func productExceptSelf(_ nums: [Int]) -> [Int] {
    var out = [Int](repeating: 1, count: nums.count)
    var prefix = 1
    for i in 0..<nums.count {
        out[i] = prefix
        prefix *= nums[i]
    }
    var suffix = 1
    for i in stride(from: nums.count - 1, through: 0, by: -1) {
        out[i] *= suffix
        suffix *= nums[i]
    }
    return out
}
```

### Dart

```dart
List<int> productExceptSelf(List<int> nums) {
  final out = List<int>.filled(nums.length, 1);
  var prefix = 1;
  for (var i = 0; i < nums.length; i++) {
    out[i] = prefix;
    prefix *= nums[i];
  }
  var suffix = 1;
  for (var i = nums.length - 1; i >= 0; i--) {
    out[i] *= suffix;
    suffix *= nums[i];
  }
  return out;
}
```

---

## Q6 — Maximum product subarray (Swift / Dart)

### Swift

```swift
func maxProduct(_ nums: [Int]) -> Int {
    var hi = nums[0], lo = nums[0], best = nums[0]
    for x in nums.dropFirst() {
        let a = hi * x, b = lo * x
        hi = max(x, a, b)
        lo = min(x, a, b)
        best = max(best, hi)
    }
    return best
}
```

### Dart

```dart
import 'dart:math';

int maxProduct(List<int> nums) {
  var hi = nums[0], lo = nums[0], best = nums[0];
  for (final x in nums.skip(1)) {
    final a = hi * x, b = lo * x;
    hi = max(x, max(a, b));
    lo = min(x, min(a, b));
    best = max(best, hi);
  }
  return best;
}
```

---

## Q10 — First missing positive (Swift / Dart)

Both ports copy the input first: Swift parameters are immutable, and in Dart the copy keeps the caller's list from being reordered.

### Swift

```swift
func firstMissingPositive(_ input: [Int]) -> Int {
    var nums = input
    let n = nums.count
    for i in 0..<n {
        while nums[i] >= 1 && nums[i] <= n && nums[nums[i] - 1] != nums[i] {
            nums.swapAt(i, nums[i] - 1)
        }
    }
    for i in 0..<n where nums[i] != i + 1 { return i + 1 }
    return n + 1
}
```

### Dart

```dart
int firstMissingPositive(List<int> input) {
  final nums = List<int>.of(input);
  final n = nums.length;
  for (var i = 0; i < n; i++) {
    while (nums[i] >= 1 && nums[i] <= n && nums[nums[i] - 1] != nums[i]) {
      final j = nums[i] - 1;
      final tmp = nums[j];
      nums[j] = nums[i];
      nums[i] = tmp;
    }
  }
  for (var i = 0; i < n; i++) {
    if (nums[i] != i + 1) return i + 1;
  }
  return n + 1;
}
```

---

- Timed protocol: **20–30 min**, complexity spoken first  

Back: [Chapter 32](../../book/part-x/32-arrays-hashing-matrix.md)
