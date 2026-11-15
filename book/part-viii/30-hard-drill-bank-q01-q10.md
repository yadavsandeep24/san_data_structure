# Chapter 30 — Hard Drill Bank (Top-Company Pace) — Q1–Q10

Part of [Chapter 30 — Hard Drill Bank (Top-Company Pace)](30-hard-drill-bank.md). Read the overview first for the timing rules and strategy.

---

## Q1. Median of Two Sorted Arrays (Fee Tier Cut)

**Topic:** Binary search / partitioning

**Statement**

Given two sorted arrays `a` and `b` (fee thresholds from two pricing tables), return the median of the merged multiset in O(log(min(m,n))) time. Framing: merge two sorted fee ladders without materializing the full merge on the UI thread.

**Approach**

Binary-search the partition of the shorter array so left sides together hold half the elements; enforce `maxLeft ≤ minRight`.

**Complexity:** Time O(log(min(m,n))), Space O(1)

### Kotlin

```kotlin
fun findMedianSortedArrays(a: IntArray, b: IntArray): Double {
    if (a.size > b.size) return findMedianSortedArrays(b, a)
    val m = a.size
    val n = b.size
    var lo = 0
    var hi = m
    val half = (m + n + 1) / 2
    while (lo <= hi) {
        val i = (lo + hi) / 2
        val j = half - i
        val aLeft = if (i == 0) Int.MIN_VALUE else a[i - 1]
        val aRight = if (i == m) Int.MAX_VALUE else a[i]
        val bLeft = if (j == 0) Int.MIN_VALUE else b[j - 1]
        val bRight = if (j == n) Int.MAX_VALUE else b[j]
        when {
            aLeft <= bRight && bLeft <= aRight -> {
                return if ((m + n) % 2 == 0)
                    (maxOf(aLeft, bLeft).toDouble() + minOf(aRight, bRight)) / 2.0
                else maxOf(aLeft, bLeft).toDouble()
            }
            aLeft > bRight -> hi = i - 1
            else -> lo = i + 1
        }
    }
    error("unreachable")
}
```

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
import 'dart:math';

double findMedianSortedArrays(List<int> a, List<int> b) {
  if (a.length > b.length) return findMedianSortedArrays(b, a);
  final m = a.length, n = b.length;
  var lo = 0, hi = m;
  final half = (m + n + 1) ~/ 2;
  while (lo <= hi) {
    final i = (lo + hi) ~/ 2;
    final j = half - i;
    final num aLeft = i == 0 ? double.negativeInfinity : a[i - 1];
    final num aRight = i == m ? double.infinity : a[i];
    final num bLeft = j == 0 ? double.negativeInfinity : b[j - 1];
    final num bRight = j == n ? double.infinity : b[j];
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

### TypeScript

```typescript
function findMedianSortedArrays(a: number[], b: number[]): number {
  if (a.length > b.length) return findMedianSortedArrays(b, a);
  const m = a.length, n = b.length;
  let lo = 0, hi = m;
  const half = (m + n + 1) >> 1;
  const NEG = Number.NEGATIVE_INFINITY, POS = Number.POSITIVE_INFINITY;
  while (lo <= hi) {
    const i = (lo + hi) >> 1;
    const j = half - i;
    const aL = i === 0 ? NEG : a[i - 1];
    const aR = i === m ? POS : a[i];
    const bL = j === 0 ? NEG : b[j - 1];
    const bR = j === n ? POS : b[j];
    if (aL <= bR && bL <= aR) {
      return (m + n) % 2 === 0
        ? (Math.max(aL, bL) + Math.min(aR, bR)) / 2
        : Math.max(aL, bL);
    }
    if (aL > bR) hi = i - 1;
    else lo = i + 1;
  }
  throw new Error("unreachable");
}
```

---

## Q2. Trapping Rain Water (Price Spike Wells)

**Topic:** Two pointers / stack

**Statement**

`height[i]` = bar height. Return total trapped water. Mobile note: same two-pointer pattern as scanning a sparkline of FX spikes without allocating a stack of indices when memory is tight.

**Approach**

Two pointers; water at a cell is limited by the **shorter** side’s max so far. Advance the side with the smaller height.

**Complexity:** Time O(n), Space O(1)

### Kotlin

```kotlin
fun trap(height: IntArray): Int {
    var lo = 0
    var hi = height.lastIndex
    var leftMax = 0
    var rightMax = 0
    var water = 0
    while (lo < hi) {
        if (height[lo] <= height[hi]) {
            if (height[lo] >= leftMax) leftMax = height[lo]
            else water += leftMax - height[lo]
            lo++
        } else {
            if (height[hi] >= rightMax) rightMax = height[hi]
            else water += rightMax - height[hi]
            hi--
        }
    }
    return water
}
```

### Swift

```swift
func trap(_ height: [Int]) -> Int {
    var lo = 0, hi = height.count - 1, leftMax = 0, rightMax = 0, water = 0
    while lo < hi {
        if height[lo] <= height[hi] {
            if height[lo] >= leftMax { leftMax = height[lo] } else { water += leftMax - height[lo] }
            lo += 1
        } else {
            if height[hi] >= rightMax { rightMax = height[hi] } else { water += rightMax - height[hi] }
            hi -= 1
        }
    }
    return water
}
```

### Dart

```dart
int trap(List<int> height) {
  var lo = 0, hi = height.length - 1, leftMax = 0, rightMax = 0, water = 0;
  while (lo < hi) {
    if (height[lo] <= height[hi]) {
      if (height[lo] >= leftMax) {
        leftMax = height[lo];
      } else {
        water += leftMax - height[lo];
      }
      lo++;
    } else {
      if (height[hi] >= rightMax) {
        rightMax = height[hi];
      } else {
        water += rightMax - height[hi];
      }
      hi--;
    }
  }
  return water;
}
```

### TypeScript

```typescript
function trap(height: number[]): number {
  let lo = 0, hi = height.length - 1, leftMax = 0, rightMax = 0, water = 0;
  while (lo < hi) {
    if (height[lo] <= height[hi]) {
      if (height[lo] >= leftMax) leftMax = height[lo];
      else water += leftMax - height[lo];
      lo++;
    } else {
      if (height[hi] >= rightMax) rightMax = height[hi];
      else water += rightMax - height[hi];
      hi--;
    }
  }
  return water;
}
```

---

## Q3. Longest Consecutive Sequence

**Topic:** Hash set

**Statement**

Return length of the longest consecutive elements sequence. O(n) expected. Framing: longest streak of consecutive settlement days in a sparse set of epoch-days.

**Approach**

Put all in a set. Only start a streak when `x-1` is absent; walk forward.

**Complexity:** Time O(n) expected, Space O(n)

### Kotlin

```kotlin
fun longestConsecutive(nums: IntArray): Int {
    val set = nums.toHashSet()
    var best = 0
    for (x in set) {
        if (x - 1 in set) continue
        var y = x
        var len = 1
        while (y + 1 in set) { y++; len++ }
        best = maxOf(best, len)
    }
    return best
}
```

### Swift

```swift
func longestConsecutive(_ nums: [Int]) -> Int {
    let set = Set(nums)
    var best = 0
    for x in set {
        if set.contains(x - 1) { continue }
        var y = x
        var len = 1
        while set.contains(y + 1) { y += 1; len += 1 }
        best = max(best, len)
    }
    return best
}
```

### Dart

```dart
int longestConsecutive(List<int> nums) {
  final set = nums.toSet();
  var best = 0;
  for (final x in set) {
    if (set.contains(x - 1)) continue;
    var y = x, len = 1;
    while (set.contains(y + 1)) {
      y++;
      len++;
    }
    if (len > best) best = len;
  }
  return best;
}
```

### TypeScript

```typescript
function longestConsecutive(nums: number[]): number {
  const set = new Set(nums);
  let best = 0;
  for (const x of set) {
    if (set.has(x - 1)) continue;
    let y = x, len = 1;
    while (set.has(y + 1)) { y++; len++; }
    best = Math.max(best, len);
  }
  return best;
}
```

---

## Q4. Word Break

**Topic:** DP / trie optional

**Statement**

Return whether `s` can be segmented into dictionary words. Framing: route deep-link path segments against an allowlist vocabulary.

**Approach**

`dp[i] = true` if prefix `s[0..i)` can be segmented. Try word endings at each true index.

**Complexity:** Time O(n² · W) naive / O(n²) with set lookups bounded by max word length, Space O(n)

### Kotlin

```kotlin
fun wordBreak(s: String, wordDict: List<String>): Boolean {
    val dict = wordDict.toHashSet()
    val n = s.length
    val dp = BooleanArray(n + 1).also { it[0] = true }
    val maxLen = dict.maxOfOrNull { it.length } ?: 0
    for (i in 0 until n) {
        if (!dp[i]) continue
        for (len in 1..minOf(maxLen, n - i)) {
            if (s.substring(i, i + len) in dict) dp[i + len] = true
        }
    }
    return dp[n]
}
```

### Swift

```swift
func wordBreak(_ s: String, _ wordDict: [String]) -> Bool {
    let dict = Set(wordDict)
    let chars = Array(s)
    let n = chars.count
    var dp = Array(repeating: false, count: n + 1)
    dp[0] = true
    let maxLen = wordDict.map(\.count).max() ?? 0
    for i in 0..<n where dp[i] {
        for len in stride(from: 1, through: min(maxLen, n - i), by: 1) {
            if dict.contains(String(chars[i..<(i + len)])) { dp[i + len] = true }
        }
    }
    return dp[n]
}
```

### Dart

```dart
import 'dart:math';

bool wordBreak(String s, List<String> wordDict) {
  final dict = wordDict.toSet();
  final n = s.length;
  final dp = List.filled(n + 1, false);
  dp[0] = true;
  final maxLen = wordDict.fold<int>(0, (m, w) => max(m, w.length));
  for (var i = 0; i < n; i++) {
    if (!dp[i]) continue;
    for (var len = 1; len <= min(maxLen, n - i); len++) {
      if (dict.contains(s.substring(i, i + len))) dp[i + len] = true;
    }
  }
  return dp[n];
}
```

### TypeScript

```typescript
function wordBreak(s: string, wordDict: string[]): boolean {
  const dict = new Set(wordDict);
  const n = s.length;
  const dp = Array(n + 1).fill(false);
  dp[0] = true;
  const maxLen = wordDict.reduce((m, w) => Math.max(m, w.length), 0);
  for (let i = 0; i < n; i++) {
    if (!dp[i]) continue;
    for (let len = 1; len <= Math.min(maxLen, n - i); len++) {
      if (dict.has(s.slice(i, i + len))) dp[i + len] = true;
    }
  }
  return dp[n];
}
```

---

## Q5. Serialize or Deserialize Binary Tree

**Topic:** Trees / BFS or preorder

**Statement**

Design algorithms to serialize a binary tree to a string and deserialize it. Framing: persist a small navigation/decision tree across process death.

**Approach**

Level-order with explicit null markers, or preorder with null sentinels.

**Complexity:** Time O(n), Space O(n)

### Kotlin

```kotlin
class TreeNode(var `val`: Int) {
    var left: TreeNode? = null
    var right: TreeNode? = null
}

class Codec {
    fun serialize(root: TreeNode?): String {
        if (root == null) return "#"
        val q = ArrayDeque<TreeNode?>()
        q.add(root)
        val out = mutableListOf<String>()
        while (q.isNotEmpty()) {
            val n = q.removeFirst()
            if (n == null) { out += "#"; continue }
            out += n.`val`.toString()
            q.add(n.left)
            q.add(n.right)
        }
        return out.joinToString(",")
    }

    fun deserialize(data: String): TreeNode? {
        if (data == "#" || data.isEmpty()) return null
        val parts = data.split(",")
        val root = TreeNode(parts[0].toInt())
        val q = ArrayDeque<TreeNode>()
        q.add(root)
        var i = 1
        while (q.isNotEmpty() && i < parts.size) {
            val n = q.removeFirst()
            if (parts[i] != "#") {
                n.left = TreeNode(parts[i].toInt()).also { q.add(it) }
            }
            i++
            if (i < parts.size && parts[i] != "#") {
                n.right = TreeNode(parts[i].toInt()).also { q.add(it) }
            }
            i++
        }
        return root
    }
}
```

### Swift

```swift
final class TreeNode {
    var val: Int
    var left: TreeNode?
    var right: TreeNode?
    init(_ val: Int) { self.val = val }
}

final class Codec {
    func serialize(_ root: TreeNode?) -> String {
        guard let root else { return "#" }
        var q: [TreeNode?] = [root]
        var head = 0
        var out: [String] = []
        while head < q.count {
            let node = q[head]
            head += 1
            guard let n = node else { out.append("#"); continue }
            out.append(String(n.val))
            q.append(n.left)
            q.append(n.right)
        }
        return out.joined(separator: ",")
    }

    func deserialize(_ data: String) -> TreeNode? {
        if data == "#" || data.isEmpty { return nil }
        let parts = data.split(separator: ",", omittingEmptySubsequences: false).map(String.init)
        guard let rootVal = Int(parts[0]) else { return nil }
        let root = TreeNode(rootVal)
        var q: [TreeNode] = [root]
        var head = 0
        var i = 1
        while head < q.count && i < parts.count {
            let n = q[head]
            head += 1
            if let v = Int(parts[i]) { // "#" → nil
                let child = TreeNode(v)
                n.left = child
                q.append(child)
            }
            i += 1
            if i < parts.count, let v = Int(parts[i]) {
                let child = TreeNode(v)
                n.right = child
                q.append(child)
            }
            i += 1
        }
        return root
    }
}
```

### Dart

```dart
import 'dart:collection';

class TreeNode {
  TreeNode(this.val);
  int val;
  TreeNode? left;
  TreeNode? right;
}

class Codec {
  String serialize(TreeNode? root) {
    if (root == null) return '#';
    final q = Queue<TreeNode?>()..add(root);
    final out = <String>[];
    while (q.isNotEmpty) {
      final n = q.removeFirst();
      if (n == null) {
        out.add('#');
        continue;
      }
      out.add('${n.val}');
      q
        ..add(n.left)
        ..add(n.right);
    }
    return out.join(',');
  }

  TreeNode? deserialize(String data) {
    if (data == '#' || data.isEmpty) return null;
    final parts = data.split(',');
    final root = TreeNode(int.parse(parts[0]));
    final q = Queue<TreeNode>()..add(root);
    var i = 1;
    while (q.isNotEmpty && i < parts.length) {
      final n = q.removeFirst();
      if (parts[i] != '#') {
        final child = TreeNode(int.parse(parts[i]));
        n.left = child;
        q.add(child);
      }
      i++;
      if (i < parts.length && parts[i] != '#') {
        final child = TreeNode(int.parse(parts[i]));
        n.right = child;
        q.add(child);
      }
      i++;
    }
    return root;
  }
}
```

### TypeScript

```typescript
class TreeNode {
  val: number;
  left: TreeNode | null = null;
  right: TreeNode | null = null;
  constructor(val = 0) { this.val = val; }
}

function serialize(root: TreeNode | null): string {
  if (!root) return "#";
  const q: (TreeNode | null)[] = [root];
  const out: string[] = [];
  while (q.length) {
    const n = q.shift()!;
    if (!n) { out.push("#"); continue; }
    out.push(String(n.val));
    q.push(n.left, n.right);
  }
  return out.join(",");
}

function deserialize(data: string): TreeNode | null {
  if (data === "#" || data === "") return null;
  const parts = data.split(",");
  const root = new TreeNode(+parts[0]);
  const q: TreeNode[] = [root];
  let i = 1;
  while (q.length && i < parts.length) {
    const n = q.shift()!;
    if (parts[i] !== "#") {
      n.left = new TreeNode(+parts[i]);
      q.push(n.left);
    }
    i++;
    if (i < parts.length && parts[i] !== "#") {
      n.right = new TreeNode(+parts[i]);
      q.push(n.right);
    }
    i++;
  }
  return root;
}
```

---

## Q6. Course Schedule II (Return Order)

**Topic:** Topological sort (Kahn)

**Statement**

`numCourses`, `prerequisites[i] = [a,b]` means b → a. Return a valid order or empty if cycle. Framing: onboarding checklist modules with dependencies.

**Approach**

Kahn: indegrees + queue of zeros; append as processed.

**Complexity:** Time O(V+E), Space O(V+E)

### Kotlin

```kotlin
fun findOrder(numCourses: Int, prerequisites: Array<IntArray>): IntArray {
    val g = Array(numCourses) { mutableListOf<Int>() }
    val indeg = IntArray(numCourses)
    for (e in prerequisites) {
        g[e[1]].add(e[0])
        indeg[e[0]]++
    }
    val q = ArrayDeque<Int>()
    for (i in 0 until numCourses) if (indeg[i] == 0) q.add(i)
    val order = IntArray(numCourses)
    var k = 0
    while (q.isNotEmpty()) {
        val u = q.removeFirst()
        order[k++] = u
        for (v in g[u]) if (--indeg[v] == 0) q.add(v)
    }
    return if (k == numCourses) order else intArrayOf()
}
```

### Swift

```swift
func findOrder(_ numCourses: Int, _ prerequisites: [[Int]]) -> [Int] {
    var g = Array(repeating: [Int](), count: numCourses)
    var indeg = Array(repeating: 0, count: numCourses)
    for e in prerequisites {
        g[e[1]].append(e[0])
        indeg[e[0]] += 1
    }
    var order = (0..<numCourses).filter { indeg[$0] == 0 } // doubles as the queue
    var head = 0
    while head < order.count {
        let u = order[head]
        head += 1
        for v in g[u] {
            indeg[v] -= 1
            if indeg[v] == 0 { order.append(v) }
        }
    }
    return order.count == numCourses ? order : []
}
```

### Dart

```dart
List<int> findOrder(int numCourses, List<List<int>> prerequisites) {
  final g = List.generate(numCourses, (_) => <int>[]);
  final indeg = List.filled(numCourses, 0);
  for (final e in prerequisites) {
    g[e[1]].add(e[0]);
    indeg[e[0]]++;
  }
  // `order` doubles as the queue; `head` is the dequeue pointer.
  final order = [for (var i = 0; i < numCourses; i++) if (indeg[i] == 0) i];
  for (var head = 0; head < order.length; head++) {
    for (final v in g[order[head]]) {
      if (--indeg[v] == 0) order.add(v);
    }
  }
  return order.length == numCourses ? order : [];
}
```

### TypeScript

```typescript
function findOrder(numCourses: number, prerequisites: number[][]): number[] {
  const g: number[][] = Array.from({ length: numCourses }, () => []);
  const indeg = Array(numCourses).fill(0);
  for (const [a, b] of prerequisites) {
    g[b].push(a);
    indeg[a]++;
  }
  const q: number[] = [];
  for (let i = 0; i < numCourses; i++) if (indeg[i] === 0) q.push(i);
  const order: number[] = [];
  while (q.length) {
    const u = q.shift()!;
    order.push(u);
    for (const v of g[u]) if (--indeg[v] === 0) q.push(v);
  }
  return order.length === numCourses ? order : [];
}
```

---

## Q7. Alien Dictionary (Harder Graph Variant)

**Topic:** Graphs / topo + unique consecutive edges

**Statement**

Given a list of words sorted in an unknown alien alphabet, return the character order (smallest lexicographically among valid if you like — here any valid order, or `""` if invalid/cycle). Harder variant of network-delay style graphs from Ch25: derive edges from adjacent word pairs.

**Approach**

Compare consecutive words; first differing chars give `u → v` (u before v). Validate prefix rule. Kahn topo.

**Complexity:** Time O(C) total chars, Space O(1) alphabet / O(Σ unique letters)

### Kotlin

```kotlin
fun alienOrder(words: Array<String>): String {
    val adj = HashMap<Char, MutableSet<Char>>()
    val indeg = HashMap<Char, Int>()
    for (w in words) for (c in w) {
        adj.putIfAbsent(c, hashSetOf())
        indeg.putIfAbsent(c, 0)
    }
    for (i in 0 until words.lastIndex) {
        val a = words[i]
        val b = words[i + 1]
        if (a.length > b.length && a.startsWith(b)) return ""
        val n = minOf(a.length, b.length)
        for (j in 0 until n) {
            if (a[j] != b[j]) {
                if (adj[a[j]]!!.add(b[j])) indeg[b[j]] = indeg[b[j]]!! + 1
                break
            }
        }
    }
    val q = ArrayDeque<Char>()
    for ((c, d) in indeg) if (d == 0) q.add(c)
    val sb = StringBuilder()
    while (q.isNotEmpty()) {
        val u = q.removeFirst()
        sb.append(u)
        for (v in adj[u]!!) {
            indeg[v] = indeg[v]!! - 1
            if (indeg[v] == 0) q.add(v)
        }
    }
    return if (sb.length == indeg.size) sb.toString() else ""
}
```

### Swift

```swift
func alienOrder(_ words: [String]) -> String {
    var adj: [Character: Set<Character>] = [:]
    var indeg: [Character: Int] = [:]
    for w in words {
        for c in w where adj[c] == nil {
            adj[c] = []
            indeg[c] = 0
        }
    }
    for (a, b) in zip(words, words.dropFirst()) {
        if a.count > b.count && a.hasPrefix(b) { return "" }
        for (x, y) in zip(a, b) where x != y {
            if adj[x, default: []].insert(y).inserted { indeg[y, default: 0] += 1 }
            break
        }
    }
    var q = indeg.filter { $0.value == 0 }.map(\.key)
    var head = 0
    var out = ""
    while head < q.count {
        let u = q[head]
        head += 1
        out.append(u)
        for v in adj[u, default: []] {
            indeg[v, default: 0] -= 1
            if indeg[v] == 0 { q.append(v) }
        }
    }
    return out.count == indeg.count ? out : ""
}
```

### Dart

```dart
import 'dart:collection';

String alienOrder(List<String> words) {
  final adj = <String, Set<String>>{};
  final indeg = <String, int>{};
  for (final w in words) {
    for (final c in w.split('')) {
      adj.putIfAbsent(c, () => <String>{});
      indeg.putIfAbsent(c, () => 0);
    }
  }
  for (var i = 0; i + 1 < words.length; i++) {
    final a = words[i], b = words[i + 1];
    if (a.length > b.length && a.startsWith(b)) return '';
    final n = a.length < b.length ? a.length : b.length;
    for (var j = 0; j < n; j++) {
      if (a[j] != b[j]) {
        if (adj[a[j]]!.add(b[j])) indeg[b[j]] = indeg[b[j]]! + 1;
        break;
      }
    }
  }
  final q = Queue<String>()..addAll([for (final e in indeg.entries) if (e.value == 0) e.key]);
  final sb = StringBuffer();
  while (q.isNotEmpty) {
    final u = q.removeFirst();
    sb.write(u);
    for (final v in adj[u]!) {
      indeg[v] = indeg[v]! - 1;
      if (indeg[v] == 0) q.add(v);
    }
  }
  return sb.length == indeg.length ? sb.toString() : '';
}
```

### TypeScript

```typescript
function alienOrder(words: string[]): string {
  const adj = new Map<string, Set<string>>();
  const indeg = new Map<string, number>();
  for (const w of words) for (const c of w) {
    if (!adj.has(c)) adj.set(c, new Set());
    if (!indeg.has(c)) indeg.set(c, 0);
  }
  for (let i = 0; i < words.length - 1; i++) {
    const a = words[i], b = words[i + 1];
    if (a.length > b.length && a.startsWith(b)) return "";
    const n = Math.min(a.length, b.length);
    for (let j = 0; j < n; j++) {
      if (a[j] !== b[j]) {
        if (!adj.get(a[j])!.has(b[j])) {
          adj.get(a[j])!.add(b[j]);
          indeg.set(b[j], (indeg.get(b[j]) ?? 0) + 1);
        }
        break;
      }
    }
  }
  const q: string[] = [];
  for (const [c, d] of indeg) if (d === 0) q.push(c);
  let out = "";
  while (q.length) {
    const u = q.shift()!;
    out += u;
    for (const v of adj.get(u)!) {
      indeg.set(v, indeg.get(v)! - 1);
      if (indeg.get(v) === 0) q.push(v);
    }
  }
  return out.length === indeg.size ? out : "";
}
```

---

## Q8. Merge Intervals and Insert Interval Combo

**Topic:** Intervals

**Statement**

(1) Merge overlapping intervals. (2) Insert a new interval into a sorted non-overlapping list and merge. Framing: merge quiet-hours windows; insert a maintenance blackout.

**Approach**

Sort by start for merge. For insert: emit before, merge overlapping, emit after.

**Complexity:** Merge O(n log n); Insert O(n)

### Kotlin

```kotlin
fun merge(intervals: Array<IntArray>): Array<IntArray> {
    if (intervals.isEmpty()) return emptyArray()
    intervals.sortBy { it[0] }
    val out = mutableListOf(intervals[0].clone())
    for (i in 1 until intervals.size) {
        val last = out.last()
        val cur = intervals[i]
        if (cur[0] <= last[1]) last[1] = maxOf(last[1], cur[1])
        else out += cur.clone()
    }
    return out.toTypedArray()
}

fun insert(intervals: Array<IntArray>, newInterval: IntArray): Array<IntArray> {
    val out = mutableListOf<IntArray>()
    var i = 0
    val n = intervals.size
    var ns = newInterval[0]
    var ne = newInterval[1]
    while (i < n && intervals[i][1] < ns) out += intervals[i++]
    while (i < n && intervals[i][0] <= ne) {
        ns = minOf(ns, intervals[i][0])
        ne = maxOf(ne, intervals[i][1])
        i++
    }
    out += intArrayOf(ns, ne)
    while (i < n) out += intervals[i++]
    return out.toTypedArray()
}
```

### Swift

```swift
func merge(_ intervals: [[Int]]) -> [[Int]] {
    guard !intervals.isEmpty else { return [] }
    let sorted = intervals.sorted { $0[0] < $1[0] }
    var out = [sorted[0]]
    for cur in sorted.dropFirst() {
        let last = out.count - 1
        if cur[0] <= out[last][1] {
            out[last][1] = max(out[last][1], cur[1])
        } else {
            out.append(cur)
        }
    }
    return out
}

func insert(_ intervals: [[Int]], _ newInterval: [Int]) -> [[Int]] {
    var out: [[Int]] = []
    var i = 0
    let n = intervals.count
    var ns = newInterval[0], ne = newInterval[1]
    while i < n && intervals[i][1] < ns { out.append(intervals[i]); i += 1 }
    while i < n && intervals[i][0] <= ne {
        ns = min(ns, intervals[i][0])
        ne = max(ne, intervals[i][1])
        i += 1
    }
    out.append([ns, ne])
    while i < n { out.append(intervals[i]); i += 1 }
    return out
}
```

### Dart

```dart
import 'dart:math';

List<List<int>> merge(List<List<int>> intervals) {
  if (intervals.isEmpty) return [];
  intervals.sort((a, b) => a[0].compareTo(b[0]));
  final out = [
    [intervals[0][0], intervals[0][1]]
  ];
  for (var i = 1; i < intervals.length; i++) {
    final last = out.last;
    final cur = intervals[i];
    if (cur[0] <= last[1]) {
      last[1] = max(last[1], cur[1]);
    } else {
      out.add([cur[0], cur[1]]);
    }
  }
  return out;
}

List<List<int>> insert(List<List<int>> intervals, List<int> newInterval) {
  final out = <List<int>>[];
  var i = 0;
  final n = intervals.length;
  var ns = newInterval[0], ne = newInterval[1];
  while (i < n && intervals[i][1] < ns) {
    out.add(intervals[i++]);
  }
  while (i < n && intervals[i][0] <= ne) {
    ns = min(ns, intervals[i][0]);
    ne = max(ne, intervals[i][1]);
    i++;
  }
  out.add([ns, ne]);
  while (i < n) {
    out.add(intervals[i++]);
  }
  return out;
}
```

### TypeScript

```typescript
function merge(intervals: number[][]): number[][] {
  if (!intervals.length) return [];
  intervals.sort((a, b) => a[0] - b[0]);
  const out: number[][] = [[intervals[0][0], intervals[0][1]]];
  for (let i = 1; i < intervals.length; i++) {
    const last = out[out.length - 1];
    const cur = intervals[i];
    if (cur[0] <= last[1]) last[1] = Math.max(last[1], cur[1]);
    else out.push([cur[0], cur[1]]);
  }
  return out;
}

function insert(intervals: number[][], newInterval: number[]): number[][] {
  const out: number[][] = [];
  let i = 0;
  const n = intervals.length;
  let [ns, ne] = newInterval;
  while (i < n && intervals[i][1] < ns) out.push(intervals[i++]);
  while (i < n && intervals[i][0] <= ne) {
    ns = Math.min(ns, intervals[i][0]);
    ne = Math.max(ne, intervals[i][1]);
    i++;
  }
  out.push([ns, ne]);
  while (i < n) out.push(intervals[i++]);
  return out;
}
```

---

## Q9. LFU Cache

**Topic:** Design / nested maps + DLL

**Statement**

Capacity `cap`. `get`/`put` O(1) average; evict **least frequently used**, tie → least recently among that freq. Framing: hot config/feature-flag cache on device.

**Approach**

`key → node`; `freq → LRU list`; track `minFreq`. On access bump freq and move lists.

**Complexity:** O(1) amortized per op

### Kotlin

```kotlin
class LFUCache(private val capacity: Int) {
    private data class Node(val key: Int, var value: Int, var freq: Int = 1)
    private val keyNode = HashMap<Int, Node>()
    private val freqList = HashMap<Int, LinkedHashSet<Int>>()
    private var minFreq = 0

    fun get(key: Int): Int {
        val n = keyNode[key] ?: return -1
        touch(n)
        return n.value
    }

    fun put(key: Int, value: Int) {
        if (capacity == 0) return
        keyNode[key]?.let {
            it.value = value
            touch(it)
            return
        }
        if (keyNode.size >= capacity) {
            val set = freqList[minFreq]!!
            val evict = set.iterator().next()
            set.remove(evict)
            keyNode.remove(evict)
        }
        val n = Node(key, value)
        keyNode[key] = n
        freqList.getOrPut(1) { LinkedHashSet() }.add(key)
        minFreq = 1
    }

    private fun touch(n: Node) {
        val f = n.freq
        freqList[f]!!.remove(n.key)
        if (freqList[f]!!.isEmpty()) {
            freqList.remove(f)
            if (minFreq == f) minFreq++
        }
        n.freq = f + 1
        freqList.getOrPut(n.freq) { LinkedHashSet() }.add(n.key)
    }
}
```

### Swift

```swift
/// Insertion-ordered key set: O(1) append / remove / first (doubly linked list over dictionaries).
struct OrderedKeySet {
    private var prev: [Int: Int] = [:]
    private var next: [Int: Int] = [:]
    private(set) var first: Int?
    private var last: Int?
    private(set) var count = 0
    var isEmpty: Bool { count == 0 }

    mutating func append(_ k: Int) {
        if let l = last { next[l] = k; prev[k] = l } else { first = k }
        last = k
        count += 1
    }

    /// Precondition: `k` is in the set.
    mutating func remove(_ k: Int) {
        let p = prev.removeValue(forKey: k), n = next.removeValue(forKey: k)
        if let p { next[p] = n } else { first = n }
        if let n { prev[n] = p } else { last = p }
        count -= 1
    }
}

final class LFUCache {
    private let cap: Int
    private var keyNode: [Int: (value: Int, freq: Int)] = [:]
    private var freqList: [Int: OrderedKeySet] = [:] // freq -> keys, LRU first
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
        if keyNode.count >= cap, let evict = freqList[minFreq]?.first {
            freqList[minFreq]?.remove(evict)
            keyNode.removeValue(forKey: evict)
        }
        keyNode[key] = (value, 1)
        freqList[1, default: OrderedKeySet()].append(key)
        minFreq = 1
    }

    private func touch(_ key: Int, _ n: (value: Int, freq: Int)) {
        let f = n.freq
        freqList[f]?.remove(key)
        if freqList[f]?.isEmpty == true {
            freqList.removeValue(forKey: f)
            if minFreq == f { minFreq += 1 }
        }
        keyNode[key] = (n.value, f + 1)
        freqList[f + 1, default: OrderedKeySet()].append(key)
    }
}
```

### Dart

```dart
class LFUCache {
  LFUCache(this.capacity);
  final int capacity;
  final _keyNode = <int, (int value, int freq)>{};
  final _freqList = <int, Set<int>>{}; // LinkedHashSet: insertion order = LRU first
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
      final set = _freqList[_minFreq]!;
      final evict = set.first;
      set.remove(evict);
      _keyNode.remove(evict);
    }
    _keyNode[key] = (value, 1);
    (_freqList[1] ??= {}).add(key);
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
    (_freqList[nf] ??= {}).add(key);
  }
}
```

### TypeScript

```typescript
class LFUCache {
  private cap: number;
  private keyNode = new Map<number, { value: number; freq: number }>();
  private freqList = new Map<number, Set<number>>(); // insertion order = LRU within freq
  private minFreq = 0;

  constructor(capacity: number) { this.cap = capacity; }

  get(key: number): number {
    const n = this.keyNode.get(key);
    if (!n) return -1;
    this.touch(key, n);
    return n.value;
  }

  put(key: number, value: number): void {
    if (this.cap === 0) return;
    const existing = this.keyNode.get(key);
    if (existing) {
      existing.value = value;
      this.touch(key, existing);
      return;
    }
    if (this.keyNode.size >= this.cap) {
      const set = this.freqList.get(this.minFreq)!;
      const evict = set.values().next().value as number;
      set.delete(evict);
      this.keyNode.delete(evict);
    }
    this.keyNode.set(key, { value, freq: 1 });
    if (!this.freqList.has(1)) this.freqList.set(1, new Set());
    this.freqList.get(1)!.add(key);
    this.minFreq = 1;
  }

  private touch(key: number, n: { value: number; freq: number }) {
    const f = n.freq;
    const set = this.freqList.get(f)!;
    set.delete(key);
    if (set.size === 0) {
      this.freqList.delete(f);
      if (this.minFreq === f) this.minFreq++;
    }
    n.freq = f + 1;
    if (!this.freqList.has(n.freq)) this.freqList.set(n.freq, new Set());
    this.freqList.get(n.freq)!.add(key);
  }
}
```

---

## Q10. Design Tweet or Timeline (Simplified)

**Topic:** Design / hash + heap merge

**Statement**

`postTweet`, `getNewsFeed(userId)` (10 most recent from self + followees), `follow`, `unfollow`. Framing: activity feed merge like a payments “notifications” rail.

**Approach**

User → tweets (newest first); follow graph. Feed: max-heap merge of up to 10 lists (pointer into each).

**Complexity:** post O(1); feed O(F log F) with F followees (bounded k=10)

### Kotlin

```kotlin
class Twitter {
    private var time = 0
    private val tweets = HashMap<Int, MutableList<Pair<Int, Int>>>() // user → (time, tweetId)
    private val follows = HashMap<Int, MutableSet<Int>>()

    fun postTweet(userId: Int, tweetId: Int) {
        tweets.getOrPut(userId) { mutableListOf() }.add(0, ++time to tweetId)
    }

    fun getNewsFeed(userId: Int): List<Int> {
        val people = (follows[userId] ?: emptySet()) + userId
        data class Item(val t: Int, val id: Int, val u: Int, val idx: Int)
        val heap = java.util.PriorityQueue<Item>(compareByDescending { it.t })
        for (u in people) {
            val list = tweets[u] ?: continue
            if (list.isNotEmpty()) heap.add(Item(list[0].first, list[0].second, u, 0))
        }
        val out = mutableListOf<Int>()
        while (out.size < 10 && heap.isNotEmpty()) {
            val cur = heap.poll()
            out += cur.id
            val list = tweets[cur.u]!!
            val ni = cur.idx + 1
            if (ni < list.size) heap.add(Item(list[ni].first, list[ni].second, cur.u, ni))
        }
        return out
    }

    fun follow(followerId: Int, followeeId: Int) {
        if (followerId != followeeId)
            follows.getOrPut(followerId) { hashSetOf() }.add(followeeId)
    }

    fun unfollow(followerId: Int, followeeId: Int) {
        follows[followerId]?.remove(followeeId)
    }
}
```

### Swift

```swift
final class Twitter {
    private var time = 0
    private var tweets: [Int: [(time: Int, id: Int)]] = [:] // newest first
    private var follows: [Int: Set<Int>] = [:]

    func postTweet(_ userId: Int, _ tweetId: Int) {
        time += 1
        tweets[userId, default: []].insert((time, tweetId), at: 0)
    }

    func getNewsFeed(_ userId: Int) -> [Int] {
        var people = follows[userId] ?? []
        people.insert(userId)
        typealias Item = (t: Int, id: Int, u: Int, idx: Int)
        var heap: [Item] = []
        func push(_ x: Item) { heap.append(x); heap.sort { $0.t > $1.t } }
        for u in people {
            if let first = tweets[u]?.first { push((first.time, first.id, u, 0)) }
        }
        var out: [Int] = []
        while out.count < 10 && !heap.isEmpty {
            let cur = heap.removeFirst()
            out.append(cur.id)
            let list = tweets[cur.u] ?? []
            let ni = cur.idx + 1
            if ni < list.count { push((list[ni].time, list[ni].id, cur.u, ni)) }
        }
        return out
    }

    func follow(_ followerId: Int, _ followeeId: Int) {
        if followerId != followeeId { follows[followerId, default: []].insert(followeeId) }
    }

    func unfollow(_ followerId: Int, _ followeeId: Int) {
        follows[followerId]?.remove(followeeId)
    }
}
```

### Dart

```dart
typedef _Item = ({int t, int id, int u, int idx});

class Twitter {
  var _time = 0;
  final _tweets = <int, List<(int time, int id)>>{}; // newest first
  final _follows = <int, Set<int>>{};

  void postTweet(int userId, int tweetId) {
    (_tweets[userId] ??= []).insert(0, (++_time, tweetId));
  }

  List<int> getNewsFeed(int userId) {
    final people = {...?_follows[userId], userId};
    final heap = <_Item>[];
    void push(_Item x) {
      heap.add(x);
      heap.sort((a, b) => b.t.compareTo(a.t));
    }

    for (final u in people) {
      final list = _tweets[u];
      if (list != null && list.isNotEmpty) {
        push((t: list[0].$1, id: list[0].$2, u: u, idx: 0));
      }
    }
    final out = <int>[];
    while (out.length < 10 && heap.isNotEmpty) {
      final cur = heap.removeAt(0);
      out.add(cur.id);
      final list = _tweets[cur.u]!;
      final ni = cur.idx + 1;
      if (ni < list.length) {
        push((t: list[ni].$1, id: list[ni].$2, u: cur.u, idx: ni));
      }
    }
    return out;
  }

  void follow(int followerId, int followeeId) {
    if (followerId != followeeId) (_follows[followerId] ??= {}).add(followeeId);
  }

  void unfollow(int followerId, int followeeId) {
    _follows[followerId]?.remove(followeeId);
  }
}
```

### TypeScript

```typescript
class Twitter {
  private time = 0;
  private tweets = new Map<number, [number, number][]>(); // [time, id]
  private follows = new Map<number, Set<number>>();

  postTweet(userId: number, tweetId: number): void {
    if (!this.tweets.has(userId)) this.tweets.set(userId, []);
    this.tweets.get(userId)!.unshift([++this.time, tweetId]);
  }

  getNewsFeed(userId: number): number[] {
    const people = new Set(this.follows.get(userId) ?? []);
    people.add(userId);
    type Item = { t: number; id: number; u: number; idx: number };
    const heap: Item[] = [];
    const push = (x: Item) => { heap.push(x); heap.sort((a, b) => b.t - a.t); };
    for (const u of people) {
      const list = this.tweets.get(u);
      if (list?.length) push({ t: list[0][0], id: list[0][1], u, idx: 0 });
    }
    const out: number[] = [];
    while (out.length < 10 && heap.length) {
      const cur = heap.shift()!;
      out.push(cur.id);
      const list = this.tweets.get(cur.u)!;
      const ni = cur.idx + 1;
      if (ni < list.length) push({ t: list[ni][0], id: list[ni][1], u: cur.u, idx: ni });
    }
    return out;
  }

  follow(followerId: number, followeeId: number): void {
    if (followerId === followeeId) return;
    if (!this.follows.has(followerId)) this.follows.set(followerId, new Set());
    this.follows.get(followerId)!.add(followeeId);
  }

  unfollow(followerId: number, followeeId: number): void {
    this.follows.get(followerId)?.delete(followeeId);
  }
}
```

*(Teaching note: the Swift, Dart and TS heaps above sort for clarity; say “binary heap O(log F)” in interview.)*

---

Previous: [Chapter 30 — Hard Drill Bank (Top-Company Pace)](30-hard-drill-bank.md) · Next: [Chapter 30 — Hard Drill Bank (Top-Company Pace) — Q11–Q20](30-hard-drill-bank-q11-q20.md) · Solutions: [`solutions/ch30`](../../solutions/ch30/README.md)
