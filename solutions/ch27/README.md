# Chapter 27 — Solution Index & Extra Ports

Full **Kotlin + TypeScript** solutions live inline in [`book/part-viii/27-hard-drill-bank.md`](../../book/part-viii/27-hard-drill-bank.md). This file adds a timed-review index plus **Swift/Dart** ports for the longest / most interview-heavy problems.

| # | Title | Topic | One-line approach |
|---|-------|-------|-------------------|
| [Q1](../../book/part-viii/27-hard-drill-bank.md#q1-median-of-two-sorted-arrays-fee-tier-cut) | Median of Two Sorted Arrays | Binary partition | Binary-search cut on shorter array so left half is balanced; median from maxL/minR |
| [Q2](../../book/part-viii/27-hard-drill-bank.md#q2-trapping-rain-water-price-spike-wells) | Trapping Rain Water | Two pointers | Advance shorter side; water = sideMax − height |
| [Q3](../../book/part-viii/27-hard-drill-bank.md#q3-longest-consecutive-sequence) | Longest Consecutive Sequence | Hash set | Only start streaks at values with no `x-1` |
| [Q4](../../book/part-viii/27-hard-drill-bank.md#q4-word-break) | Word Break | DP | `dp[i]` if prefix segments; try dict words from true indices |
| [Q5](../../book/part-viii/27-hard-drill-bank.md#q5-serialize--deserialize-binary-tree) | Serialize / Deserialize Tree | BFS | Level-order with `#` null markers |
| [Q6](../../book/part-viii/27-hard-drill-bank.md#q6-course-schedule-ii-return-order) | Course Schedule II | Kahn topo | Indegree queue; emit order; empty if cycle |
| [Q7](../../book/part-viii/27-hard-drill-bank.md#q7-alien-dictionary-harder-graph-variant) | Alien Dictionary | Topo edges | Adjacent word diffs → edges; Kahn; reject bad prefixes |
| [Q8](../../book/part-viii/27-hard-drill-bank.md#q8-merge-intervals--insert-interval-combo) | Merge + Insert Intervals | Intervals | Sort+sweep merge; insert: before / overlap / after |
| [Q9](../../book/part-viii/27-hard-drill-bank.md#q9-lfu-cache) | LFU Cache | Design | key→node; freq→LRU set; bump freq; evict minFreq LRU |
| [Q10](../../book/part-viii/27-hard-drill-bank.md#q10-design-tweet--timeline-simplified) | Design Twitter | Heap merge | Per-user tweets + follow set; max-heap merge top 10 |
| [Q11](../../book/part-viii/27-hard-drill-bank.md#q11-longest-substring-with-at-most-k-distinct-characters) | Longest Substring ≤ K Distinct | Sliding window | Expand right; shrink while distinct > k |
| [Q12](../../book/part-viii/27-hard-drill-bank.md#q12-edit-distance) | Edit Distance | DP | Levenshtein; roll 2 rows |
| [Q13](../../book/part-viii/27-hard-drill-bank.md#q13-binary-tree-maximum-path-sum) | Max Path Sum | Tree DP | Return upward gain; global = bend through node |
| [Q14](../../book/part-viii/27-hard-drill-bank.md#q14-find-median-from-data-stream) | Median Data Stream | Two heaps | Max-heap low + min-heap high; balance sizes |
| [Q15](../../book/part-viii/27-hard-drill-bank.md#q15-accounts-merge-union-find-hard) | Accounts Merge | Union-Find | Union emails in an account; group by root; sort |
| [Q16](../../book/part-viii/27-hard-drill-bank.md#q16-regular-expression-matching) | Regex Matching | DP | `dp[i][j]` with `*` = empty or extend match |
| [Q17](../../book/part-viii/27-hard-drill-bank.md#q17-bus-routes-hard-bfs) | Bus Routes | Hard BFS | BFS stops; expand via unused buses; count bus hops |
| [Q18](../../book/part-viii/27-hard-drill-bank.md#q18-parallel-courses--minimum-semesters) | Parallel Courses | Layered topo | Kahn by layers; each layer = one semester |
| [Q19](../../book/part-viii/27-hard-drill-bank.md#q19-design-hit-counter-rate-limit-window) | Hit Counter | Queue | Push timestamps; pop older than window |
| [Q20](../../book/part-viii/27-hard-drill-bank.md#q20-currency-conversion-arbitrage-bellman-ford) | FX Arbitrage | Bellman-Ford | Edge weight `-ln(rate)`; negative cycle ⇒ arbitrage |

---

## Q1 — Median of two sorted arrays (Swift / Dart)

### Swift

```swift
func findMedianSortedArrays(_ a: [Int], _ b: [Int]) -> Double {
    if a.count > b.count { return findMedianSortedArrays(b, a) }
    let m = a.count, n = b.count
    var lo = 0, hi = m
    let half = (m + n + 1) / 2
    while lo <= hi {
        let i = (lo + hi) / 2
        let j = half - i
        let aLeft = i == 0 ? Int.min : a[i - 1]
        let aRight = i == m ? Int.max : a[i]
        let bLeft = j == 0 ? Int.min : b[j - 1]
        let bRight = j == n ? Int.max : b[j]
        if aLeft <= bRight && bLeft <= aRight {
            if (m + n) % 2 == 0 {
                return Double(max(aLeft, bLeft) + min(aRight, bRight)) / 2.0
            }
            return Double(max(aLeft, bLeft))
        } else if aLeft > bRight { hi = i - 1 }
        else { lo = i + 1 }
    }
    fatalError("unreachable")
}
```

### Dart

```dart
double findMedianSortedArrays(List<int> a, List<int> b) {
  if (a.length > b.length) return findMedianSortedArrays(b, a);
  final m = a.length, n = b.length;
  var lo = 0, hi = m;
  final half = (m + n + 1) ~/ 2;
  while (lo <= hi) {
    final i = (lo + hi) ~/ 2;
    final j = half - i;
    final aLeft = i == 0 ? -0x7fffffff : a[i - 1];
    final aRight = i == m ? 0x7fffffff : a[i];
    final bLeft = j == 0 ? -0x7fffffff : b[j - 1];
    final bRight = j == n ? 0x7fffffff : b[j];
    if (aLeft <= bRight && bLeft <= aRight) {
      if ((m + n) % 2 == 1) return max(aLeft, bLeft).toDouble();
      return (max(aLeft, bLeft) + min(aRight, bRight)) / 2.0;
    } else if (aLeft > bRight) {
      hi = i - 1;
    } else {
      lo = i + 1;
    }
  }
  throw StateError('unreachable');
}
```

---

## Q9 — LFU cache (Swift / Dart)

### Swift

```swift
final class LFUCache {
    private let cap: Int
    private var keyNode: [Int: (value: Int, freq: Int)] = [:]
    private var freqList: [Int: [Int]] = [:] // freq -> keys, MRU at end
    private var minFreq = 0

    init(_ capacity: Int) { cap = capacity }

    func get(_ key: Int) -> Int {
        guard let n = keyNode[key] else { return -1 }
        touch(key, n)
        return n.value
    }

    func put(_ key: Int, _ value: Int) {
        guard cap > 0 else { return }
        if var n = keyNode[key] {
            n.value = value
            keyNode[key] = n
            touch(key, n)
            return
        }
        if keyNode.count >= cap {
            var list = freqList[minFreq]!
            let evict = list.removeFirst()
            keyNode.removeValue(forKey: evict)
            freqList[minFreq] = list
        }
        keyNode[key] = (value, 1)
        freqList[1, default: []].append(key)
        minFreq = 1
    }

    private func touch(_ key: Int, _ n: (value: Int, freq: Int)) {
        let f = n.freq
        freqList[f]?.removeAll { $0 == key }
        if freqList[f]?.isEmpty == true {
            freqList.removeValue(forKey: f)
            if minFreq == f { minFreq += 1 }
        }
        let nf = f + 1
        keyNode[key] = (n.value, nf)
        freqList[nf, default: []].append(key)
    }
}
```

### Dart

```dart
class LFUCache {
  LFUCache(this.capacity);
  final int capacity;
  final _keyNode = <int, (int value, int freq)>{};
  final _freqList = <int, List<int>>{};
  var _minFreq = 0;

  int get(int key) {
    final n = _keyNode[key];
    if (n == null) return -1;
    _touch(key, n);
    return n.$1;
  }

  void put(int key, int value) {
    if (capacity == 0) return;
    final existing = _keyNode[key];
    if (existing != null) {
      _keyNode[key] = (value, existing.$2);
      _touch(key, (value, existing.$2));
      return;
    }
    if (_keyNode.length >= capacity) {
      final list = _freqList[_minFreq]!;
      final evict = list.removeAt(0);
      _keyNode.remove(evict);
    }
    _keyNode[key] = (value, 1);
    (_freqList[1] ??= []).add(key);
    _minFreq = 1;
  }

  void _touch(int key, (int, int) n) {
    final f = n.$2;
    _freqList[f]!.remove(key);
    if (_freqList[f]!.isEmpty) {
      _freqList.remove(f);
      if (_minFreq == f) _minFreq++;
    }
    final nf = f + 1;
    _keyNode[key] = (n.$1, nf);
    (_freqList[nf] ??= []).add(key);
  }
}
```

---

## Q14 — Find median from data stream (TypeScript two-heap / Swift / Dart)

### TypeScript (binary heap sketch)

```typescript
class MedianFinderHeaps {
  private low: number[] = [];
  private high: number[] = [];

  private less(a: number, b: number) { return a < b; }

  private pushHeap(h: number[], x: number, isMax: boolean) {
    h.push(x);
    let i = h.length - 1;
    while (i > 0) {
      const p = (i - 1) >> 1;
      const ok = isMax ? h[i] <= h[p] : h[i] >= h[p];
      if (ok) break;
      [h[i], h[p]] = [h[p], h[i]];
      i = p;
    }
  }

  private popHeap(h: number[], isMax: boolean): number {
    const top = h[0];
    const last = h.pop()!;
    if (h.length) {
      h[0] = last;
      this.siftDown(h, 0, isMax);
    }
    return top;
  }

  private siftDown(h: number[], i: number, isMax: boolean) {
    for (;;) {
      let best = i;
      const l = i * 2 + 1, r = l + 1;
      const better = (a: number, b: number) => isMax ? a > b : a < b;
      if (l < h.length && better(h[l], h[best])) best = l;
      if (r < h.length && better(h[r], h[best])) best = r;
      if (best === i) break;
      [h[i], h[best]] = [h[best], h[i]];
      i = best;
    }
  }

  addNum(num: number): void {
    this.pushHeap(this.low, num, true);
    this.pushHeap(this.high, this.popHeap(this.low, true), false);
    if (this.high.length > this.low.length) {
      this.pushHeap(this.low, this.popHeap(this.high, false), true);
    }
  }

  findMedian(): number {
    if (this.low.length > this.high.length) return this.low[0];
    return (this.low[0] + this.high[0]) / 2;
  }
}
```

### Swift

```swift
final class MedianFinder {
    private var low: [Int] = [] // max-heap
    private var high: [Int] = [] // min-heap

    func addNum(_ num: Int) {
        low.append(num); low.sort(by: >)
        high.append(low.removeLast()); high.sort()
        if high.count > low.count {
            low.append(high.removeFirst()); low.sort(by: >)
        }
    }

    func findMedian() -> Double {
        if low.count > high.count { return Double(low[0]) }
        return Double(low[0] + high[0]) / 2.0
    }
}
```

*(Contest/production: replace sorted inserts with binary heaps as in TypeScript above.)*

### Dart

```dart
class MedianFinder {
  final _low = <int>[]; // max via sort desc
  final _high = <int>[];

  void addNum(int num) {
    _low.add(num);
    _low.sort((a, b) => b.compareTo(a));
    _high.add(_low.removeLast());
    _high.sort();
    if (_high.length > _low.length) {
      _low.add(_high.removeAt(0));
      _low.sort((a, b) => b.compareTo(a));
    }
  }

  double findMedian() {
    if (_low.length > _high.length) return _low.first.toDouble();
    return (_low.first + _high.first) / 2.0;
  }
}
```

---

## Q16 — Regular expression matching (Swift / Dart)

### Swift

```swift
func isMatch(_ s: String, _ p: String) -> Bool {
    let s = Array(s), p = Array(p)
    let m = s.count, n = p.count
    var dp = Array(repeating: Array(repeating: false, count: n + 1), count: m + 1)
    dp[0][0] = true
    if n >= 2 {
        for j in stride(from: 2, through: n, by: 2) where p[j - 1] == "*" {
            dp[0][j] = dp[0][j - 2]
        }
    }
    for i in 1...m {
        for j in 1...n {
            if p[j - 1] == "*" {
                dp[i][j] = dp[i][j - 2] ||
                    ((p[j - 2] == "." || p[j - 2] == s[i - 1]) && dp[i - 1][j])
            } else if p[j - 1] == "." || p[j - 1] == s[i - 1] {
                dp[i][j] = dp[i - 1][j - 1]
            }
        }
    }
    return dp[m][n]
}
```

### Dart

```dart
bool isMatch(String s, String p) {
  final m = s.length, n = p.length;
  final dp = List.generate(m + 1, (_) => List.filled(n + 1, false));
  dp[0][0] = true;
  for (var j = 2; j <= n; j++) {
    if (p[j - 1] == '*' && dp[0][j - 2]) dp[0][j] = true;
  }
  for (var i = 1; i <= m; i++) {
    for (var j = 1; j <= n; j++) {
      if (p[j - 1] == '*') {
        dp[i][j] = dp[i][j - 2] ||
            ((p[j - 2] == '.' || p[j - 2] == s[i - 1]) && dp[i - 1][j]);
      } else if (p[j - 1] == '.' || p[j - 1] == s[i - 1]) {
        dp[i][j] = dp[i - 1][j - 1];
      }
    }
  }
  return dp[m][n];
}
```

---

## Q20 — Currency arbitrage (Swift / Dart)

### Swift

```swift
func hasArbitrage(_ pairs: [(String, String, Double)]) -> Bool {
    var nodes = Set<String>()
    for (a, b, _) in pairs { nodes.insert(a); nodes.insert(b) }
    let list = Array(nodes)
    let idx = Dictionary(uniqueKeysWithValues: list.enumerated().map { ($1, $0) })
    let n = list.count
    let edges = pairs.map { (a, b, rate) in (idx[a]!, idx[b]!, -log(rate)) }
    var dist = Array(repeating: 0.0, count: n)
    for _ in 0..<(n - 1) {
        for (u, v, w) in edges where dist[v] > dist[u] + w { dist[v] = dist[u] + w }
    }
    for (u, v, w) in edges where dist[v] > dist[u] + w + 1e-12 { return true }
    return false
}
```

### Dart

```dart
import 'dart:math';

bool hasArbitrage(List<(String, String, double)> pairs) {
  final nodes = <String>{};
  for (final (a, b, _) in pairs) {
    nodes.add(a);
    nodes.add(b);
  }
  final list = nodes.toList();
  final idx = {for (var i = 0; i < list.length; i++) list[i]: i};
  final n = list.length;
  final edges = pairs
      .map((e) => (idx[e.$1]!, idx[e.$2]!, -log(e.$3)))
      .toList();
  final dist = List.filled(n, 0.0);
  for (var i = 0; i < n - 1; i++) {
    for (final (u, v, w) in edges) {
      if (dist[v] > dist[u] + w) dist[v] = dist[u] + w;
    }
  }
  for (final (u, v, w) in edges) {
    if (dist[v] > dist[u] + w + 1e-12) return true;
  }
  return false;
}
```

---

## Counts

- **20** hard drills — Kotlin + TS in chapter  
- **6** problems with extra Swift/Dart ports here (Q1, Q9, Q14, Q16, Q20 + TS heap Q14)  
- Timed protocol: **45–55 min**, complexity spoken first  

Back: [Chapter 27](../../book/part-viii/27-hard-drill-bank.md)
