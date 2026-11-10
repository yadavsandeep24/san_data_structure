# Chapter 27 — Hard Drill Bank (Top-Company Pace)

Bridge from the Chapter 24 medium bank to **top-fintech / FAANG-mobile** toughness. Same mobile framing habit; harder algorithms and design.

Companion index: [`solutions/ch27/README.md`](../../solutions/ch27/README.md)

---

## How to use

| Protocol | Detail |
|----------|--------|
| **Time** | 45–55 minutes per problem when practicing “onsite hard” |
| **Open** | Restate, examples, edges (3–5 min) |
| **Speak first** | Structure + **time/space complexity before code** |
| **Code** | Happy path mid-window; edges in the last 8–10 min |
| **Languages** | All four inline for every problem: **Kotlin, Swift, Dart, TypeScript** (same algorithm, same names); `solutions/ch27` adds a binary-heap TS variant for Q14 |
| **Mobile tell** | One sentence: main-thread risk, cache bound, or money/idempotency if relevant |

Do **not** skim all 20 in one sitting. Rotate: 2 hard / day in Appendix A weeks **14–15** (fintech track), or earlier if you are already strong on Ch 24.

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

## Q5. Serialize / Deserialize Binary Tree

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

Given a list of words sorted in an unknown alien alphabet, return the character order (smallest lexicographically among valid if you like — here any valid order, or `""` if invalid/cycle). Harder variant of network-delay style graphs from Ch20: derive edges from adjacent word pairs.

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

## Q8. Merge Intervals + Insert Interval Combo

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

## Q10. Design Tweet / Timeline (Simplified)

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

**Say in interview:** “Production code uses binary heaps for O(log n) `addNum`; Kotlin above uses `PriorityQueue`; the Swift/Dart/TS versions use sorted inserts for clarity.” Binary-heap TypeScript version: [`solutions/ch27`](../../solutions/ch27/README.md#q14-find-median-from-data-stream-typescript-two-heap-swift-dart).

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

## Drill checklist (say aloud)

1. Complexity **before** code.  
2. Name the structure (heap, UF, DP table, mono deque…).  
3. One mobile / fintech sentence.  
4. Edges: empty, cycle, capacity 0, same source/target, floating money (refuse).  
5. If stuck: brute force correctly, then remove repeated work.

Previous: [Chapter 26 — Money & Idempotency](26-money-idempotency-reliability.md)
