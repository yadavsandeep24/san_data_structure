# Chapter 37 — Solution Index & Extra Ports

Full **Kotlin + TypeScript** solutions live inline in [`book/part-x/37-graphs-dynamic-programming.md`](../../book/part-x/37-graphs-dynamic-programming.md). This file adds a timed-review index plus a standalone copy of the **Swift/Dart** versions of the most interview-heavy problems. All four languages are also inline in the chapter.

| # | Title | Topic | One-line approach |
|---|-------|-------|-------------------|
| [Q1](../../book/part-x/37-graphs-dynamic-programming.md#q1-max-area-of-island-largest-heatmap-region) | Max Area of Island | Grid DFS (iterative) | Iterative DFS with stack; mark visited in place |
| [Q2](../../book/part-x/37-graphs-dynamic-programming.md#q2-rotting-oranges-offline-update-spread) | Rotting Oranges | Multi-source BFS | Multi-source BFS by layers; count fresh |
| [Q3](../../book/part-x/37-graphs-dynamic-programming.md#q3-pacific-atlantic-water-flow-map-tiles-draining-to-both-coasts) | Pacific Atlantic Water Flow | Reverse BFS from borders | Uphill BFS from each ocean's border; intersect |
| [Q4](../../book/part-x/37-graphs-dynamic-programming.md#q4-surrounded-regions-paint-bucket-capture) | Surrounded Regions | Border flood fill | Flood border O's to safe; flip the rest |
| [Q5](../../book/part-x/37-graphs-dynamic-programming.md#q5-graph-valid-tree-folder-hierarchy-sanity-check) | Graph Valid Tree | Union-Find | n−1 edges + union-find (by size) finds no cycle |
| [Q6](../../book/part-x/37-graphs-dynamic-programming.md#q6-min-cost-climbing-stairs-cheapest-onboarding-path) | Min Cost Climbing Stairs | 1-D DP | dp[i] = min(dp[i-1]+c[i-1], dp[i-2]+c[i-2]) |
| [Q7](../../book/part-x/37-graphs-dynamic-programming.md#q7-house-robber-ii-circular-carousel-ad-slots) | House Robber II | 1-D DP (two passes) | Linear robber on [0..n-2] and [1..n-1] |
| [Q8](../../book/part-x/37-graphs-dynamic-programming.md#q8-decode-ways-ambiguous-numeric-codes) | Decode Ways | 1-D DP | dp[i] = one-digit + valid two-digit ways |
| [Q9](../../book/part-x/37-graphs-dynamic-programming.md#q9-longest-increasing-subsequence-longest-rising-streak) | Longest Increasing Subsequence | DP + binary search (patience) | Patience tails + binary search |
| [Q10](../../book/part-x/37-graphs-dynamic-programming.md#q10-combination-sum-iv-ordered-top-up-sequences) | Combination Sum IV | 1-D DP (order matters) | Amount outer loop: ways[t] += ways[t-x] |
| [Q11](../../book/part-x/37-graphs-dynamic-programming.md#q11-longest-common-subsequence-diffing-two-lists) | Longest Common Subsequence | 2-D DP (rolled to 1-D) | Rolling row with diag carry |
| [Q12](../../book/part-x/37-graphs-dynamic-programming.md#q12-best-time-to-buy-and-sell-stock-with-cooldown-price-chart-cooldown-rule) | Best Time to Buy and Sell Stock with Cooldown | State-machine DP | hold / sold / rest state machine |
| [Q13](../../book/part-x/37-graphs-dynamic-programming.md#q13-coin-change-ii-ways-to-make-change-at-the-till) | Coin Change II | 1-D DP (unbounded knapsack) | Coin outer loop: ways[a] += ways[a-coin] |
| [Q14](../../book/part-x/37-graphs-dynamic-programming.md#q14-target-sum-signed-ledger-adjustments) | Target Sum | 0/1 knapsack (subset count) | Subset count for (total+target)/2, backwards loop |

---

## Q3 — Pacific Atlantic Water Flow (Swift / Dart)

### Swift

```swift
func pacificAtlantic(_ heights: [[Int]]) -> [[Int]] {
    let rows = heights.count, cols = heights.first?.count ?? 0
    let dirs = [1, 0, -1, 0, 1]
    func flood(_ seeds: [Int]) -> [Bool] { // walk uphill from the ocean
        var seen = [Bool](repeating: false, count: rows * cols)
        var queue: [Int] = []
        for s in seeds where !seen[s] { seen[s] = true; queue.append(s) }
        var head = 0
        while head < queue.count {
            let cell = queue[head]; head += 1
            let r = cell / cols, c = cell % cols
            for d in 0..<4 {
                let nr = r + dirs[d], nc = c + dirs[d + 1]
                if nr < 0 || nr >= rows || nc < 0 || nc >= cols { continue }
                let next = nr * cols + nc
                if !seen[next] && heights[nr][nc] >= heights[r][c] {
                    seen[next] = true
                    queue.append(next)
                }
            }
        }
        return seen
    }
    let pacific = flood(Array(0..<cols) + (0..<rows).map { $0 * cols })
    let atlantic = flood((0..<cols).map { (rows - 1) * cols + $0 } + (0..<rows).map { $0 * cols + cols - 1 })
    return (0..<(rows * cols)).filter { pacific[$0] && atlantic[$0] }.map { [$0 / cols, $0 % cols] }
}
```

### Dart

```dart
List<List<int>> pacificAtlantic(List<List<int>> heights) {
  final rows = heights.length, cols = heights[0].length;
  const dirs = [1, 0, -1, 0, 1];
  List<bool> flood(List<int> seeds) { // walk uphill from the ocean
    final seen = List<bool>.filled(rows * cols, false);
    final queue = <int>[];
    for (final s in seeds) {
      if (!seen[s]) { seen[s] = true; queue.add(s); }
    }
    for (var head = 0; head < queue.length; head++) {
      final cell = queue[head];
      final r = cell ~/ cols, c = cell % cols;
      for (var d = 0; d < 4; d++) {
        final nr = r + dirs[d], nc = c + dirs[d + 1];
        if (nr < 0 || nr >= rows || nc < 0 || nc >= cols) continue;
        final next = nr * cols + nc;
        if (!seen[next] && heights[nr][nc] >= heights[r][c]) {
          seen[next] = true;
          queue.add(next);
        }
      }
    }
    return seen;
  }
  final pacific = flood([for (var c = 0; c < cols; c++) c, for (var r = 0; r < rows; r++) r * cols]);
  final atlantic = flood([
    for (var c = 0; c < cols; c++) (rows - 1) * cols + c,
    for (var r = 0; r < rows; r++) r * cols + cols - 1,
  ]);
  return [
    for (var i = 0; i < rows * cols; i++)
      if (pacific[i] && atlantic[i]) [i ~/ cols, i % cols],
  ];
}
```

---

## Q9 — Longest Increasing Subsequence (Swift / Dart)

### Swift

```swift
func lengthOfLIS(_ nums: [Int]) -> Int {
    var tails: [Int] = [] // tails[k] = smallest tail of an increasing run of length k+1
    for x in nums {
        var lo = 0, hi = tails.count
        while lo < hi {
            let mid = (lo + hi) / 2
            if tails[mid] < x { lo = mid + 1 } else { hi = mid }
        }
        if lo == tails.count { tails.append(x) } else { tails[lo] = x }
    }
    return tails.count
}
```

### Dart

```dart
int lengthOfLIS(List<int> nums) {
  final tails = <int>[]; // tails[k] = smallest tail of an increasing run of length k+1
  for (final x in nums) {
    var lo = 0, hi = tails.length;
    while (lo < hi) {
      final mid = (lo + hi) >> 1;
      if (tails[mid] < x) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
    if (lo == tails.length) {
      tails.add(x);
    } else {
      tails[lo] = x;
    }
  }
  return tails.length;
}
```

---

## Q14 — Target Sum (Swift / Dart)

### Swift

```swift
func findTargetSumWays(_ nums: [Int], _ target: Int) -> Int {
    let total = nums.reduce(0, +)
    if abs(target) > total || (total + target) % 2 != 0 { return 0 }
    let want = (total + target) / 2 // sum of the '+' group
    var ways = [Int](repeating: 0, count: want + 1)
    ways[0] = 1
    for x in nums {
        var s = want
        while s >= x { ways[s] += ways[s - x]; s -= 1 } // 0/1 knapsack, backwards
    }
    return ways[want]
}
```

### Dart

```dart
int findTargetSumWays(List<int> nums, int target) {
  final total = nums.fold(0, (a, b) => a + b);
  if (target.abs() > total || (total + target) % 2 != 0) return 0;
  final want = (total + target) ~/ 2; // sum of the '+' group
  final ways = List<int>.filled(want + 1, 0);
  ways[0] = 1;
  for (final x in nums) {
    for (var s = want; s >= x; s--) {
      ways[s] += ways[s - x]; // 0/1 knapsack, backwards
    }
  }
  return ways[want];
}
```

---

Back to [Chapter 37](../../book/part-x/37-graphs-dynamic-programming.md).
