# Chapter 33 — Solution Index & Extra Ports

Full **Kotlin + TypeScript** solutions live inline in [`book/part-x/33-two-pointers-windows-intervals.md`](../../book/part-x/33-two-pointers-windows-intervals.md). All four languages (Kotlin, Swift, Dart, TypeScript) are inline in the chapter. This file adds a timed-review index and repeats the **Swift/Dart** ports for three problems.

| # | Title | Topic | One-line approach |
|---|-------|-------|-------------------|
| [Q1](../../book/part-x/33-two-pointers-windows-intervals.md#q1-valid-palindrome-coupon-code-check) | Valid Palindrome | Two pointers | Skip non-alphanumerics from both ends; compare lowercased |
| [Q2](../../book/part-x/33-two-pointers-windows-intervals.md#q2-two-sum-ii-input-array-is-sorted-sorted-price-pair) | Two Sum II — Input Array Is Sorted | Two pointers | Ends inward; sum small → left++, big → right--; Long sum; 1-based |
| [Q3](../../book/part-x/33-two-pointers-windows-intervals.md#q3-3sum-zero-net-settlement-triples) | 3Sum | Sort + two pointers | Sort; fix a[i] (skip dups, stop at > 0); Two Sum II on the rest; skip dup lefts |
| [Q4](../../book/part-x/33-two-pointers-windows-intervals.md#q4-container-with-most-water-widest-chart-band) | Container With Most Water | Two pointers | Start widest; area = width × shorter; move the shorter side |
| [Q5](../../book/part-x/33-two-pointers-windows-intervals.md#q5-best-time-to-buy-and-sell-stock-one-trade-profit) | Best Time to Buy and Sell Stock | Running min | Track min so far; best = max(price − min) |
| [Q6](../../book/part-x/33-two-pointers-windows-intervals.md#q6-longest-repeating-character-replacement-fix-k-typos-in-a-streak) | Longest Repeating Character Replacement | Variable window | Grow right, track maxFreq; shrink while len − maxFreq > k |
| [Q7](../../book/part-x/33-two-pointers-windows-intervals.md#q7-permutation-in-string-scrambled-code-search) | Permutation in String | Fixed window | Window of `len(s1)` with need counts + missing counter; missing 0 → true |
| [Q8](../../book/part-x/33-two-pointers-windows-intervals.md#q8-minimum-window-substring-shortest-log-span-covering-all-events) | Minimum Window Substring | Variable window | Grow until missing 0; record; shrink until a needed char leaves |
| [Q9](../../book/part-x/33-two-pointers-windows-intervals.md#q9-minimum-size-subarray-sum-shortest-run-to-reach-a-spend-goal) | Minimum Size Subarray Sum | Variable window | Grow sum; while sum ≥ target record length and shrink; positives only |
| [Q10](../../book/part-x/33-two-pointers-windows-intervals.md#q10-find-all-anagrams-in-a-string-every-scrambled-match) | Find All Anagrams in a String | Fixed window | Q7 window; record start each time missing hits 0 |
| [Q11](../../book/part-x/33-two-pointers-windows-intervals.md#q11-minimum-number-of-arrows-to-burst-balloons-fewest-sync-ticks) | Minimum Number of Arrows to Burst Balloons | Intervals greedy | Sort by end; arrow at end; new arrow when start > arrow |
| [Q12](../../book/part-x/33-two-pointers-windows-intervals.md#q12-interval-list-intersections-shared-free-slots) | Interval List Intersections | Two pointers | Overlap = [max starts, min ends] if valid; advance the one ending first |

---

## Q3 — 3Sum (Swift / Dart)

### Swift

```swift
func threeSum(_ nums: [Int]) -> [[Int]] {
    let a = nums.sorted()
    var out: [[Int]] = []
    for i in 0..<a.count {
        if a[i] > 0 { break }
        if i > 0 && a[i] == a[i - 1] { continue }
        var lo = i + 1, hi = a.count - 1
        while lo < hi {
            let sum = a[i] + a[lo] + a[hi]
            if sum < 0 { lo += 1 }
            else if sum > 0 { hi -= 1 }
            else {
                out.append([a[i], a[lo], a[hi]])
                lo += 1
                hi -= 1
                while lo < hi && a[lo] == a[lo - 1] { lo += 1 }
            }
        }
    }
    return out
}
```

### Dart

```dart
List<List<int>> threeSum(List<int> nums) {
  final a = List<int>.of(nums)..sort();
  final out = <List<int>>[];
  for (var i = 0; i < a.length; i++) {
    if (a[i] > 0) break;
    if (i > 0 && a[i] == a[i - 1]) continue;
    var lo = i + 1, hi = a.length - 1;
    while (lo < hi) {
      final sum = a[i] + a[lo] + a[hi];
      if (sum < 0) {
        lo++;
      } else if (sum > 0) {
        hi--;
      } else {
        out.add([a[i], a[lo], a[hi]]);
        lo++;
        hi--;
        while (lo < hi && a[lo] == a[lo - 1]) lo++;
      }
    }
  }
  return out;
}
```

---

## Q8 — Minimum window substring (Swift / Dart)

Swift works on UTF-8 bytes (O(1) indexing); Dart uses UTF-16 code units, hence the 65,536-slot table.

### Swift

```swift
func minWindow(_ s: String, _ t: String) -> String {
    let sa = Array(s.utf8), ta = Array(t.utf8)
    if ta.isEmpty || ta.count > sa.count { return "" }
    var need = [Int](repeating: 0, count: 256)
    for c in ta { need[Int(c)] += 1 }
    var missing = ta.count
    var left = 0, bestStart = 0, bestLen = Int.max
    for right in 0..<sa.count {
        if need[Int(sa[right])] > 0 { missing -= 1 }
        need[Int(sa[right])] -= 1
        while missing == 0 {
            if right - left + 1 < bestLen {
                bestLen = right - left + 1
                bestStart = left
            }
            need[Int(sa[left])] += 1
            if need[Int(sa[left])] > 0 { missing += 1 }
            left += 1
        }
    }
    if bestLen == Int.max { return "" }
    return String(decoding: sa[bestStart..<bestStart + bestLen], as: UTF8.self)
}
```

### Dart

```dart
String minWindow(String s, String t) {
  if (t.isEmpty || t.length > s.length) return '';
  final need = List<int>.filled(65536, 0);
  for (final c in t.codeUnits) need[c]++;
  var missing = t.length;
  var left = 0, bestStart = 0, bestLen = -1;
  for (var right = 0; right < s.length; right++) {
    if (need[s.codeUnitAt(right)]-- > 0) missing--;
    while (missing == 0) {
      if (bestLen == -1 || right - left + 1 < bestLen) {
        bestLen = right - left + 1;
        bestStart = left;
      }
      if (++need[s.codeUnitAt(left)] > 0) missing++;
      left++;
    }
  }
  return bestLen == -1 ? '' : s.substring(bestStart, bestStart + bestLen);
}
```

---

## Q12 — Interval list intersections (Swift / Dart)

### Swift

```swift
func intervalIntersection(_ a: [[Int]], _ b: [[Int]]) -> [[Int]] {
    var out: [[Int]] = []
    var i = 0, j = 0
    while i < a.count && j < b.count {
        let lo = max(a[i][0], b[j][0])
        let hi = min(a[i][1], b[j][1])
        if lo <= hi { out.append([lo, hi]) }
        if a[i][1] < b[j][1] { i += 1 } else { j += 1 }
    }
    return out
}
```

### Dart

```dart
import 'dart:math';

List<List<int>> intervalIntersection(List<List<int>> a, List<List<int>> b) {
  final out = <List<int>>[];
  var i = 0, j = 0;
  while (i < a.length && j < b.length) {
    final lo = max(a[i][0], b[j][0]);
    final hi = min(a[i][1], b[j][1]);
    if (lo <= hi) out.add([lo, hi]);
    if (a[i][1] < b[j][1]) {
      i++;
    } else {
      j++;
    }
  }
  return out;
}
```

---

- Timed protocol: **20–30 min** (Q8: 40), complexity spoken first  

Back: [Chapter 33](../../book/part-x/33-two-pointers-windows-intervals.md)
