# Chapter 30 — Hard Drill Bank (Top-Company Pace) — Q11–Q20

Part of [Chapter 30 — Hard Drill Bank (Top-Company Pace)](30-hard-drill-bank.md). Read the overview first for the timing rules and strategy.

---

## Q11. Longest Substring with At Most K Distinct Characters

**Topic:** Sliding window

**Statement**

Longest substring of `s` with ≤ `k` distinct chars. Hard follow-up to window-max: same window skeleton, different invariant.

**Approach**

Expand right; shrink left while distinct count > k; track best length.

**Complexity:** Time O(n), Space O(|Σ|)

### Kotlin

```kotlin
fun lengthOfLongestSubstringKDistinct(s: String, k: Int): Int {
    if (k == 0) return 0
    val freq = HashMap<Char, Int>()
    var lo = 0
    var best = 0
    for (hi in s.indices) {
        freq[s[hi]] = (freq[s[hi]] ?: 0) + 1
        while (freq.size > k) {
            val c = s[lo++]
            freq[c] = freq[c]!! - 1
            if (freq[c] == 0) freq.remove(c)
        }
        best = maxOf(best, hi - lo + 1)
    }
    return best
}
```

### Swift

```swift
func lengthOfLongestSubstringKDistinct(_ s: String, _ k: Int) -> Int {
    if k == 0 { return 0 }
    let chars = Array(s)
    var freq: [Character: Int] = [:]
    var lo = 0, best = 0
    for hi in chars.indices {
        freq[chars[hi], default: 0] += 1
        while freq.count > k {
            let c = chars[lo]
            lo += 1
            freq[c, default: 0] -= 1
            if freq[c] == 0 { freq.removeValue(forKey: c) }
        }
        best = max(best, hi - lo + 1)
    }
    return best
}
```

### Dart

```dart
int lengthOfLongestSubstringKDistinct(String s, int k) {
  if (k == 0) return 0;
  final freq = <String, int>{};
  var lo = 0, best = 0;
  for (var hi = 0; hi < s.length; hi++) {
    freq[s[hi]] = (freq[s[hi]] ?? 0) + 1;
    while (freq.length > k) {
      final c = s[lo++];
      freq[c] = freq[c]! - 1;
      if (freq[c] == 0) freq.remove(c);
    }
    best = best > (hi - lo + 1) ? best : (hi - lo + 1);
  }
  return best;
}
```

### TypeScript

```typescript
function lengthOfLongestSubstringKDistinct(s: string, k: number): number {
  if (k === 0) return 0;
  const freq = new Map<string, number>();
  let lo = 0, best = 0;
  for (let hi = 0; hi < s.length; hi++) {
    freq.set(s[hi], (freq.get(s[hi]) ?? 0) + 1);
    while (freq.size > k) {
      const c = s[lo++];
      freq.set(c, freq.get(c)! - 1);
      if (freq.get(c) === 0) freq.delete(c);
    }
    best = Math.max(best, hi - lo + 1);
  }
  return best;
}
```

---

## Q12. Edit Distance

**Topic:** DP

**Statement**

Min operations (insert/delete/replace) to turn `word1` into `word2`. Framing: fuzzy match of payee names / IFSC typos with a distance budget.

**Approach**

Classic Levenshtein 2-row DP.

**Complexity:** Time O(mn), Space O(min(m,n))

### Kotlin

```kotlin
fun minDistance(word1: String, word2: String): Int {
    val m = word1.length
    val n = word2.length
    var prev = IntArray(n + 1) { it }
    for (i in 1..m) {
        val cur = IntArray(n + 1)
        cur[0] = i
        for (j in 1..n) {
            cur[j] = if (word1[i - 1] == word2[j - 1]) prev[j - 1]
            else 1 + minOf(prev[j], cur[j - 1], prev[j - 1])
        }
        prev = cur
    }
    return prev[n]
}
```

### Swift

```swift
func minDistance(_ word1: String, _ word2: String) -> Int {
    let a = Array(word1), b = Array(word2)
    let m = a.count, n = b.count
    var prev = Array(0...n)
    for i in stride(from: 1, through: m, by: 1) {
        var cur = Array(repeating: 0, count: n + 1)
        cur[0] = i
        for j in stride(from: 1, through: n, by: 1) {
            cur[j] = a[i - 1] == b[j - 1]
                ? prev[j - 1]
                : 1 + min(prev[j], cur[j - 1], prev[j - 1])
        }
        prev = cur
    }
    return prev[n]
}
```

### Dart

```dart
import 'dart:math';

int minDistance(String word1, String word2) {
  final m = word1.length, n = word2.length;
  var prev = List.generate(n + 1, (j) => j);
  for (var i = 1; i <= m; i++) {
    final cur = List.filled(n + 1, 0);
    cur[0] = i;
    for (var j = 1; j <= n; j++) {
      cur[j] = word1[i - 1] == word2[j - 1]
          ? prev[j - 1]
          : 1 + min(min(prev[j], cur[j - 1]), prev[j - 1]);
    }
    prev = cur;
  }
  return prev[n];
}
```

### TypeScript

```typescript
function minDistance(word1: string, word2: string): number {
  const m = word1.length, n = word2.length;
  let prev = Array.from({ length: n + 1 }, (_, j) => j);
  for (let i = 1; i <= m; i++) {
    const cur = Array(n + 1).fill(0);
    cur[0] = i;
    for (let j = 1; j <= n; j++) {
      cur[j] = word1[i - 1] === word2[j - 1]
        ? prev[j - 1]
        : 1 + Math.min(prev[j], cur[j - 1], prev[j - 1]);
    }
    prev = cur;
  }
  return prev[n];
}
```

---

## Q13. Binary Tree Maximum Path Sum

**Topic:** Trees / DFS gain

**Statement**

Max path sum anywhere in the tree (path may bend through a node). Framing: max contiguous “gain corridor” in a score tree — classic hard tree DP.

**Approach**

For each node return gain if path continues upward: `val + max(0, left, right)`. Update global with `val + max(0,left) + max(0,right)`.

**Complexity:** Time O(n), Space O(h)

### Kotlin

```kotlin
fun maxPathSum(root: TreeNode?): Int {
    var best = Int.MIN_VALUE
    fun gain(n: TreeNode?): Int {
        if (n == null) return 0
        val l = maxOf(0, gain(n.left))
        val r = maxOf(0, gain(n.right))
        best = maxOf(best, n.`val` + l + r)
        return n.`val` + maxOf(l, r)
    }
    gain(root)
    return best
}
```

### Swift

```swift
func maxPathSum(_ root: TreeNode?) -> Int {
    var best = Int.min
    func gain(_ n: TreeNode?) -> Int {
        guard let n else { return 0 }
        let l = max(0, gain(n.left))
        let r = max(0, gain(n.right))
        best = max(best, n.val + l + r)
        return n.val + max(l, r)
    }
    _ = gain(root)
    return best
}
```

### Dart

```dart
import 'dart:math';

int maxPathSum(TreeNode root) {
  var best = root.val; // any real path beats a sentinel
  int gain(TreeNode? n) {
    if (n == null) return 0;
    final l = max(0, gain(n.left));
    final r = max(0, gain(n.right));
    best = max(best, n.val + l + r);
    return n.val + max(l, r);
  }

  gain(root);
  return best;
}
```

### TypeScript

```typescript
function maxPathSum(root: TreeNode | null): number {
  let best = -Infinity;
  function gain(n: TreeNode | null): number {
    if (!n) return 0;
    const l = Math.max(0, gain(n.left));
    const r = Math.max(0, gain(n.right));
    best = Math.max(best, n.val + l + r);
    return n.val + Math.max(l, r);
  }
  gain(root);
  return best;
}
```

---

## Q14. Find Median from Data Stream

**Topic:** Two heaps

**Statement**

Online `addNum` / `findMedian`. Framing: live median of transaction sizes in a session analytics overlay.

**Approach**

Max-heap (lower half) + min-heap (upper); balance sizes.

**Complexity:** add O(log n), median O(1)

### Kotlin

```kotlin
class MedianFinder {
    private val low = java.util.PriorityQueue<Int>(compareByDescending { it })
    private val high = java.util.PriorityQueue<Int>()

    fun addNum(num: Int) {
        low.add(num)
        high.add(low.poll())
        if (high.size > low.size) low.add(high.poll())
    }

    fun findMedian(): Double =
        if (low.size > high.size) low.peek().toDouble()
        else (low.peek() + high.peek()) / 2.0
}
```

### Swift

```swift
final class MedianFinder {
    private var low: [Int] = [] // max-heap
    private var high: [Int] = [] // min-heap

    func addNum(_ num: Int) {
        low.append(num); low.sort(by: >)
        high.append(low.removeFirst()); high.sort()
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

### Dart

```dart
class MedianFinder {
  final _low = <int>[]; // max via sort desc
  final _high = <int>[];

  void addNum(int num) {
    _low.add(num);
    _low.sort((a, b) => b.compareTo(a));
    _high.add(_low.removeAt(0));
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

### TypeScript

```typescript
class MedianFinder {
  private low: number[] = []; // max-heap via negate compare
  private high: number[] = []; // min-heap

  private pushMax(h: number[], x: number) {
    h.push(x);
    h.sort((a, b) => b - a);
  }
  private pushMin(h: number[], x: number) {
    h.push(x);
    h.sort((a, b) => a - b);
  }
  private popMax(h: number[]): number {
    return h.shift()!;
  }
  private popMin(h: number[]): number {
    return h.shift()!;
  }

  addNum(num: number): void {
    this.pushMax(this.low, num);
    this.pushMin(this.high, this.popMax(this.low));
    if (this.high.length > this.low.length) this.pushMax(this.low, this.popMin(this.high));
  }

  findMedian(): number {
    if (this.low.length > this.high.length) return this.low[0];
    return (this.low[0] + this.high[0]) / 2;
  }
}
```

**Say in interview:** “Production code uses binary heaps for O(log n) `addNum`; Kotlin above uses `PriorityQueue`; the Swift/Dart/TS versions use sorted inserts for clarity.” Binary-heap TypeScript version: [`solutions/ch30`](../../solutions/ch30/README.md#q14--find-median-from-data-stream-typescript-two-heap--swift--dart).

---

## Q15. Accounts Merge (Union-Find Hard)

**Topic:** Union-Find / graphs

**Statement**

Accounts are `[name, email…]`. Merge accounts that share any email. Return merged lists sorted. Framing: merge merchant customer profiles that share emails across devices.

**Approach**

Union emails that co-occur; map email → name; group by root; sort.

**Complexity:** Time ~O(E α(n) + E log E), Space O(E)

### Kotlin

```kotlin
fun accountsMerge(accounts: List<List<String>>): List<List<String>> {
    val parent = HashMap<String, String>()
    val emailName = HashMap<String, String>()
    fun find(x: String): String {
        if (parent[x] != x) parent[x] = find(parent[x]!!)
        return parent[x]!!
    }
    fun union(a: String, b: String) {
        parent[find(a)] = find(b)
    }
    for (acc in accounts) {
        val name = acc[0]
        for (i in 1 until acc.size) {
            val e = acc[i]
            parent.putIfAbsent(e, e)
            emailName[e] = name
            union(acc[1], e)
        }
    }
    val groups = HashMap<String, MutableList<String>>()
    for (e in parent.keys) {
        groups.getOrPut(find(e)) { mutableListOf() }.add(e)
    }
    return groups.map { (root, emails) ->
        emails.sort()
        mutableListOf(emailName[root]!!).also { it.addAll(emails) }
    }
}
```

### Swift

```swift
func accountsMerge(_ accounts: [[String]]) -> [[String]] {
    var parent: [String: String] = [:]
    var emailName: [String: String] = [:]
    func find(_ x: String) -> String {
        let p = parent[x] ?? x
        if p == x { return x }
        let root = find(p)
        parent[x] = root
        return root
    }
    func union(_ a: String, _ b: String) {
        parent[find(a)] = find(b)
    }
    for acc in accounts {
        guard let name = acc.first, acc.count > 1 else { continue }
        for e in acc.dropFirst() {
            if parent[e] == nil { parent[e] = e }
            emailName[e] = name
            union(acc[1], e)
        }
    }
    var groups: [String: [String]] = [:]
    for e in parent.keys { groups[find(e), default: []].append(e) }
    return groups.map { root, emails in [emailName[root] ?? ""] + emails.sorted() }
}
```

### Dart

```dart
List<List<String>> accountsMerge(List<List<String>> accounts) {
  final parent = <String, String>{};
  final emailName = <String, String>{};
  String find(String x) {
    final p = parent[x] ?? x;
    if (p == x) return x;
    final root = find(p);
    parent[x] = root;
    return root;
  }

  void union(String a, String b) => parent[find(a)] = find(b);

  for (final acc in accounts) {
    final name = acc[0];
    for (var i = 1; i < acc.length; i++) {
      final e = acc[i];
      parent.putIfAbsent(e, () => e);
      emailName[e] = name;
      union(acc[1], e);
    }
  }
  final groups = <String, List<String>>{};
  for (final e in parent.keys.toList()) {
    (groups[find(e)] ??= []).add(e);
  }
  return [
    for (final MapEntry(key: root, value: emails) in groups.entries)
      [emailName[root]!, ...(emails..sort())]
  ];
}
```

### TypeScript

```typescript
function accountsMerge(accounts: string[][]): string[][] {
  const parent = new Map<string, string>();
  const emailName = new Map<string, string>();
  const find = (x: string): string => {
    if (parent.get(x) !== x) parent.set(x, find(parent.get(x)!));
    return parent.get(x)!;
  };
  const union = (a: string, b: string) => parent.set(find(a), find(b));
  for (const acc of accounts) {
    const name = acc[0];
    for (let i = 1; i < acc.length; i++) {
      const e = acc[i];
      if (!parent.has(e)) parent.set(e, e);
      emailName.set(e, name);
      union(acc[1], e);
    }
  }
  const groups = new Map<string, string[]>();
  for (const e of parent.keys()) {
    const r = find(e);
    if (!groups.has(r)) groups.set(r, []);
    groups.get(r)!.push(e);
  }
  return [...groups.entries()].map(([root, emails]) => {
    emails.sort();
    return [emailName.get(root)!, ...emails];
  });
}
```

---

## Q16. Regular Expression Matching

**Topic:** DP

**Statement**

Implement `.` and `*` matching full string (LeetCode 10). Framing: validate masked card / account patterns in offline form validators (not a substitute for real tokenization).

**Approach**

`dp[i][j]` = `s[:i]` matches `p[:j]`. Handle `*` as zero-or-more of previous.

**Complexity:** Time O(mn), Space O(mn) (compressible)

### Kotlin

```kotlin
fun isMatch(s: String, p: String): Boolean {
    val m = s.length
    val n = p.length
    val dp = Array(m + 1) { BooleanArray(n + 1) }
    dp[0][0] = true
    for (j in 2..n) if (p[j - 1] == '*' && dp[0][j - 2]) dp[0][j] = true
    for (i in 1..m) for (j in 1..n) {
        when {
            p[j - 1] == '*' -> {
                dp[i][j] = dp[i][j - 2] ||
                    ((p[j - 2] == '.' || p[j - 2] == s[i - 1]) && dp[i - 1][j])
            }
            p[j - 1] == '.' || p[j - 1] == s[i - 1] -> dp[i][j] = dp[i - 1][j - 1]
        }
    }
    return dp[m][n]
}
```

### Swift

```swift
func isMatch(_ s: String, _ p: String) -> Bool {
    let s = Array(s), p = Array(p)
    let m = s.count, n = p.count
    var dp = Array(repeating: Array(repeating: false, count: n + 1), count: m + 1)
    dp[0][0] = true
    for j in stride(from: 2, through: n, by: 1) where p[j - 1] == "*" && dp[0][j - 2] {
        dp[0][j] = true
    }
    for i in stride(from: 1, through: m, by: 1) {
        for j in stride(from: 1, through: n, by: 1) {
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

### TypeScript

```typescript
function isMatch(s: string, p: string): boolean {
  const m = s.length, n = p.length;
  const dp = Array.from({ length: m + 1 }, () => Array(n + 1).fill(false));
  dp[0][0] = true;
  for (let j = 2; j <= n; j++) if (p[j - 1] === "*" && dp[0][j - 2]) dp[0][j] = true;
  for (let i = 1; i <= m; i++) {
    for (let j = 1; j <= n; j++) {
      if (p[j - 1] === "*") {
        dp[i][j] = dp[i][j - 2] ||
          ((p[j - 2] === "." || p[j - 2] === s[i - 1]) && dp[i - 1][j]);
      } else if (p[j - 1] === "." || p[j - 1] === s[i - 1]) {
        dp[i][j] = dp[i - 1][j - 1];
      }
    }
  }
  return dp[m][n];
}
```

---

## Q17. Bus Routes (Hard BFS)

**Topic:** BFS on routes

**Statement**

`routes[i]` = stops of bus i. Return min buses to go `source → target` (−1 if impossible). Framing: min hops across partner rail corridors / UPI app deep-link graphs — BFS on **buses**, not stops.

**Approach**

Map stop → buses. BFS buses (or stops with bus-count). Mark visited buses.

**Complexity:** Time O(Σ |route|), Space O(Σ |route|)

### Kotlin

```kotlin
fun numBusesToDestination(routes: Array<IntArray>, source: Int, target: Int): Int {
    if (source == target) return 0
    val stopToBus = HashMap<Int, MutableList<Int>>()
    for (b in routes.indices) for (s in routes[b])
        stopToBus.getOrPut(s) { mutableListOf() }.add(b)
    val q = ArrayDeque<Int>()
    val seenBus = BooleanArray(routes.size)
    val seenStop = HashSet<Int>()
    q.add(source)
    seenStop.add(source)
    var buses = 0
    while (q.isNotEmpty()) {
        buses++
        repeat(q.size) {
            val stop = q.removeFirst()
            for (b in stopToBus[stop] ?: emptyList()) {
                if (seenBus[b]) continue
                seenBus[b] = true
                for (ns in routes[b]) {
                    if (ns == target) return buses
                    if (seenStop.add(ns)) q.add(ns)
                }
            }
        }
    }
    return -1
}
```

### Swift

```swift
func numBusesToDestination(_ routes: [[Int]], _ source: Int, _ target: Int) -> Int {
    if source == target { return 0 }
    var stopToBus: [Int: [Int]] = [:]
    for (b, route) in routes.enumerated() {
        for s in route { stopToBus[s, default: []].append(b) }
    }
    var q = [source]
    var seenBus = Array(repeating: false, count: routes.count)
    var seenStop: Set<Int> = [source]
    var buses = 0
    while !q.isEmpty {
        buses += 1
        var next: [Int] = []
        for stop in q {
            for b in stopToBus[stop] ?? [] where !seenBus[b] {
                seenBus[b] = true
                for ns in routes[b] {
                    if ns == target { return buses }
                    if seenStop.insert(ns).inserted { next.append(ns) }
                }
            }
        }
        q = next
    }
    return -1
}
```

### Dart

```dart
int numBusesToDestination(List<List<int>> routes, int source, int target) {
  if (source == target) return 0;
  final stopToBus = <int, List<int>>{};
  for (var b = 0; b < routes.length; b++) {
    for (final s in routes[b]) {
      (stopToBus[s] ??= []).add(b);
    }
  }
  var q = [source];
  final seenBus = List.filled(routes.length, false);
  final seenStop = {source};
  var buses = 0;
  while (q.isNotEmpty) {
    buses++;
    final next = <int>[];
    for (final stop in q) {
      for (final b in stopToBus[stop] ?? const <int>[]) {
        if (seenBus[b]) continue;
        seenBus[b] = true;
        for (final ns in routes[b]) {
          if (ns == target) return buses;
          if (seenStop.add(ns)) next.add(ns);
        }
      }
    }
    q = next;
  }
  return -1;
}
```

### TypeScript

```typescript
function numBusesToDestination(routes: number[][], source: number, target: number): number {
  if (source === target) return 0;
  const stopToBus = new Map<number, number[]>();
  routes.forEach((r, b) => r.forEach((s) => {
    if (!stopToBus.has(s)) stopToBus.set(s, []);
    stopToBus.get(s)!.push(b);
  }));
  const q: number[] = [source];
  const seenBus = new Set<number>();
  const seenStop = new Set<number>([source]);
  let buses = 0;
  while (q.length) {
    buses++;
    const size = q.length;
    for (let i = 0; i < size; i++) {
      const stop = q.shift()!;
      for (const b of stopToBus.get(stop) ?? []) {
        if (seenBus.has(b)) continue;
        seenBus.add(b);
        for (const ns of routes[b]) {
          if (ns === target) return buses;
          if (!seenStop.has(ns)) { seenStop.add(ns); q.push(ns); }
        }
      }
    }
  }
  return -1;
}
```

---

## Q18. Parallel Courses / Minimum Semesters

**Topic:** Topo + levels

**Statement**

`n` courses, relations `[a,b]` = a before b. Return min semesters (take any number of 0-indegree courses in parallel) or −1 if cycle.

**Approach**

Kahn by layers; each layer = one semester.

**Complexity:** Time O(V+E), Space O(V+E)

### Kotlin

```kotlin
fun minimumSemesters(n: Int, relations: Array<IntArray>): Int {
    val g = Array(n + 1) { mutableListOf<Int>() }
    val indeg = IntArray(n + 1)
    for (e in relations) {
        g[e[0]].add(e[1])
        indeg[e[1]]++
    }
    val q = ArrayDeque<Int>()
    for (i in 1..n) if (indeg[i] == 0) q.add(i)
    var sem = 0
    var taken = 0
    while (q.isNotEmpty()) {
        sem++
        repeat(q.size) {
            val u = q.removeFirst()
            taken++
            for (v in g[u]) if (--indeg[v] == 0) q.add(v)
        }
    }
    return if (taken == n) sem else -1
}
```

### Swift

```swift
func minimumSemesters(_ n: Int, _ relations: [[Int]]) -> Int {
    var g = Array(repeating: [Int](), count: n + 1)
    var indeg = Array(repeating: 0, count: n + 1)
    for e in relations {
        g[e[0]].append(e[1])
        indeg[e[1]] += 1
    }
    var q = stride(from: 1, through: n, by: 1).filter { indeg[$0] == 0 }
    var sem = 0, taken = 0
    while !q.isEmpty {
        sem += 1
        var next: [Int] = []
        for u in q {
            taken += 1
            for v in g[u] {
                indeg[v] -= 1
                if indeg[v] == 0 { next.append(v) }
            }
        }
        q = next
    }
    return taken == n ? sem : -1
}
```

### Dart

```dart
int minimumSemesters(int n, List<List<int>> relations) {
  final g = List.generate(n + 1, (_) => <int>[]);
  final indeg = List.filled(n + 1, 0);
  for (final e in relations) {
    g[e[0]].add(e[1]);
    indeg[e[1]]++;
  }
  var q = [for (var i = 1; i <= n; i++) if (indeg[i] == 0) i];
  var sem = 0, taken = 0;
  while (q.isNotEmpty) {
    sem++;
    final next = <int>[];
    for (final u in q) {
      taken++;
      for (final v in g[u]) {
        if (--indeg[v] == 0) next.add(v);
      }
    }
    q = next;
  }
  return taken == n ? sem : -1;
}
```

### TypeScript

```typescript
function minimumSemesters(n: number, relations: number[][]): number {
  const g: number[][] = Array.from({ length: n + 1 }, () => []);
  const indeg = Array(n + 1).fill(0);
  for (const [a, b] of relations) { g[a].push(b); indeg[b]++; }
  const q: number[] = [];
  for (let i = 1; i <= n; i++) if (indeg[i] === 0) q.push(i);
  let sem = 0, taken = 0;
  while (q.length) {
    sem++;
    const size = q.length;
    for (let i = 0; i < size; i++) {
      const u = q.shift()!;
      taken++;
      for (const v of g[u]) if (--indeg[v] === 0) q.push(v);
    }
  }
  return taken === n ? sem : -1;
}
```

---

## Q19. Design Hit Counter (Rate Limit Window)

**Topic:** Design / queue

**Statement**

Record hits with timestamps (seconds); return hits in past 300 seconds. Framing: client-side soft rate-limit telemetry before calling a payment API (server still enforces).

**Approach**

Queue of timestamps; on get, drop `< t-299`. Optional: bucket by second.

**Complexity:** hit O(1) amortized, getHits O(k) expired pops

### Kotlin

```kotlin
class HitCounter {
    private val q = ArrayDeque<Int>()
    fun hit(timestamp: Int) { q.add(timestamp) }
    fun getHits(timestamp: Int): Int {
        while (q.isNotEmpty() && q.first() <= timestamp - 300) q.removeFirst()
        return q.size
    }
}
```

### Swift

```swift
final class HitCounter {
    private var q: [Int] = []
    func hit(_ timestamp: Int) { q.append(timestamp) }
    func getHits(_ timestamp: Int) -> Int {
        while let f = q.first, f <= timestamp - 300 { q.removeFirst() }
        return q.count
    }
}
```

### Dart

```dart
import 'dart:collection';

class HitCounter {
  final _q = Queue<int>();
  void hit(int timestamp) => _q.add(timestamp);
  int getHits(int timestamp) {
    while (_q.isNotEmpty && _q.first <= timestamp - 300) {
      _q.removeFirst();
    }
    return _q.length;
  }
}
```

### TypeScript

```typescript
class HitCounter {
  private q: number[] = [];
  hit(timestamp: number): void { this.q.push(timestamp); }
  getHits(timestamp: number): number {
    while (this.q.length && this.q[0] <= timestamp - 300) this.q.shift();
    return this.q.length;
  }
}
```

---

## Q20. Currency Conversion Arbitrage (Bellman-Ford)

**Topic:** Graphs / Bellman-Ford / cycles

**Statement**

Given conversion rates as edges `(from, to, rate)` meaning `1 from = rate to`, detect whether an **arbitrage** exists (a cycle whose product of rates > 1). Return true if arbitrage exists.

**Fintech classic:** work in log space: weight `w = -log(rate)`. Product > 1 ⇔ sum of `-log` < 0, i.e. a **negative cycle** in that graph. (Equivalently: weight `+log(rate)` and hunt a **positive** cycle — same idea.)

**Approach**

Build graph on currencies; Bellman-Ford `|V|` relaxations; if an extra relaxation improves distance → negative cycle → arbitrage.

**Complexity:** Time O(V·E), Space O(V+E)

### Kotlin

```kotlin
fun hasArbitrage(pairs: List<Triple<String, String, Double>>): Boolean {
    val nodes = linkedSetOf<String>()
    for ((a, b, _) in pairs) { nodes += a; nodes += b }
    val idx = nodes.withIndex().associate { it.value to it.index }
    val n = nodes.size
    val edges = pairs.map { (a, b, rate) ->
        Triple(idx[a]!!, idx[b]!!, -kotlin.math.ln(rate))
    }
    val dist = DoubleArray(n) { 0.0 } // 0 allows detecting cycle reachable from any component
    repeat(n - 1) {
        for ((u, v, w) in edges) if (dist[v] > dist[u] + w) dist[v] = dist[u] + w
    }
    for ((u, v, w) in edges) if (dist[v] > dist[u] + w + 1e-12) return true
    return false
}
```

### Swift

```swift
import Foundation

func hasArbitrage(_ pairs: [(String, String, Double)]) -> Bool {
    var nodes = Set<String>()
    for (a, b, _) in pairs { nodes.insert(a); nodes.insert(b) }
    let list = Array(nodes)
    let idx = Dictionary(uniqueKeysWithValues: list.enumerated().map { ($1, $0) })
    let n = list.count
    let edges = pairs.map { (a, b, rate) in (idx[a]!, idx[b]!, -log(rate)) }
    var dist = Array(repeating: 0.0, count: n)
    for _ in 0..<max(0, n - 1) {
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

### TypeScript

```typescript
function hasArbitrage(pairs: [string, string, number][]): boolean {
  const nodes = new Set<string>();
  for (const [a, b] of pairs) { nodes.add(a); nodes.add(b); }
  const list = [...nodes];
  const idx = new Map(list.map((c, i) => [c, i]));
  const n = list.length;
  const edges = pairs.map(([a, b, rate]) => [idx.get(a)!, idx.get(b)!, -Math.log(rate)] as const);
  const dist = Array(n).fill(0);
  for (let i = 0; i < n - 1; i++) {
    for (const [u, v, w] of edges) if (dist[v] > dist[u] + w) dist[v] = dist[u] + w;
  }
  for (const [u, v, w] of edges) if (dist[v] > dist[u] + w + 1e-12) return true;
  return false;
}
```

**Interview talk track:** never multiply many floats of rates for the decision — use logs; still treat rates as market data with tolerances (`1e-12`). Client apps rarely run arbitrage scanners; the question tests graph fluency under a money story.

---

Previous: [Chapter 30 — Hard Drill Bank (Top-Company Pace) — Q1–Q10](30-hard-drill-bank-q01-q10.md) · Next: [Chapter 31 — Arrays, Hashing & Matrix — Pattern Drills](31-arrays-hashing-matrix.md) · Solutions: [`solutions/ch30`](../../solutions/ch30/README.md)
