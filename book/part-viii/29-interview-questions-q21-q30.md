# Chapter 29 — Interview Questions, Mobile-Dev Focused — Q21–Q30

Part of [Chapter 29 — Interview Questions, Mobile-Dev Focused](29-interview-questions.md). Read the overview first for the timing rules and strategy.

---

## Q21. Number of Provinces (Connected Components)

**Topic:** Graphs BFS/DFS

**Statement**

`isConnected[i][j] == 1` means cities linked. Count provinces. Framing: count sync clusters of devices.

**Approach**

DFS/BFS/Union-Find over unvisited nodes; each start increments count.

**Complexity:** Time O(n²) for matrix, Space O(n)

### Kotlin

```kotlin
fun findCircleNum(isConnected: Array<IntArray>): Int {
    val n = isConnected.size
    val seen = BooleanArray(n)
    fun dfs(i: Int) {
        seen[i] = true
        for (j in 0 until n) if (isConnected[i][j] == 1 && !seen[j]) dfs(j)
    }
    var provinces = 0
    for (i in 0 until n) if (!seen[i]) { provinces++; dfs(i) }
    return provinces
}
```

### Swift

```swift
func findCircleNum(_ isConnected: [[Int]]) -> Int {
    let n = isConnected.count
    var seen = Array(repeating: false, count: n)
    func dfs(_ i: Int) {
        seen[i] = true
        for j in 0..<n where isConnected[i][j] == 1 && !seen[j] { dfs(j) }
    }
    var provinces = 0
    for i in 0..<n where !seen[i] { provinces += 1; dfs(i) }
    return provinces
}
```

### Dart

```dart
int findCircleNum(List<List<int>> isConnected) {
  final n = isConnected.length;
  final seen = List<bool>.filled(n, false);
  void dfs(int i) {
    seen[i] = true;
    for (var j = 0; j < n; j++) {
      if (isConnected[i][j] == 1 && !seen[j]) dfs(j);
    }
  }
  var provinces = 0;
  for (var i = 0; i < n; i++) {
    if (!seen[i]) { provinces++; dfs(i); }
  }
  return provinces;
}
```

### TypeScript

```typescript
function findCircleNum(isConnected: number[][]): number {
  const n = isConnected.length;
  const seen: boolean[] = Array(n).fill(false);
  function dfs(i: number): void {
    seen[i] = true;
    for (let j = 0; j < n; j++) if (isConnected[i][j] === 1 && !seen[j]) dfs(j);
  }
  let provinces = 0;
  for (let i = 0; i < n; i++) if (!seen[i]) { provinces++; dfs(i); }
  return provinces;
}
```

## Q22. Clone Graph

**Topic:** Graphs BFS/DFS

**Statement**

Deep-clone a connected undirected graph of nodes with neighbor lists. Framing: snapshot a social “nearby” graph for offline.

**Approach**

Hash map `old → new`. DFS/BFS: create clone, then wire neighbors via map.

**Complexity:** Time O(V+E), Space O(V)

### Kotlin

```kotlin
class GraphNode(var `val`: Int, val neighbors: MutableList<GraphNode> = mutableListOf())
fun cloneGraph(node: GraphNode?): GraphNode? {
    if (node == null) return null
    val map = HashMap<GraphNode, GraphNode>() // identity keys: no equals override
    fun dfs(n: GraphNode): GraphNode {
        map[n]?.let { return it }
        val c = GraphNode(n.`val`)
        map[n] = c
        for (nb in n.neighbors) c.neighbors.add(dfs(nb))
        return c
    }
    return dfs(node)
}
```

### Swift

```swift
final class GraphNode {
    var val: Int
    var neighbors: [GraphNode]
    init(_ val: Int, _ neighbors: [GraphNode] = []) { self.val = val; self.neighbors = neighbors }
}
func cloneGraph(_ node: GraphNode?) -> GraphNode? {
    guard let node else { return nil }
    var map: [ObjectIdentifier: GraphNode] = [:]   // identity keys
    func dfs(_ n: GraphNode) -> GraphNode {
        if let c = map[ObjectIdentifier(n)] { return c }
        let c = GraphNode(n.val)
        map[ObjectIdentifier(n)] = c
        for nb in n.neighbors { c.neighbors.append(dfs(nb)) }
        return c
    }
    return dfs(node)
}
```

### Dart

```dart
class GraphNode {
  int val; List<GraphNode> neighbors;
  GraphNode(this.val, [List<GraphNode>? neighbors]) : neighbors = neighbors ?? [];
}
GraphNode? cloneGraph(GraphNode? node) {
  if (node == null) return null;
  final map = <GraphNode, GraphNode>{};
  GraphNode dfs(GraphNode n) {
    if (map.containsKey(n)) return map[n]!;
    final c = GraphNode(n.val);
    map[n] = c;
    for (final nb in n.neighbors) c.neighbors.add(dfs(nb));
    return c;
  }
  return dfs(node);
}
```

### TypeScript

```typescript
class GraphNode {
  val: number; neighbors: GraphNode[];
  constructor(val = 0, neighbors: GraphNode[] = []) { this.val = val; this.neighbors = neighbors; }
}
function cloneGraph(node: GraphNode | null): GraphNode | null {
  if (!node) return null;
  const map = new Map<GraphNode, GraphNode>();
  function dfs(n: GraphNode): GraphNode {
    if (map.has(n)) return map.get(n)!;
    const c = new GraphNode(n.val);
    map.set(n, c);
    for (const nb of n.neighbors) c.neighbors.push(dfs(nb));
    return c;
  }
  return dfs(node);
}
```

## Q23. Course Schedule (Cycle Detect)

**Topic:** Graphs BFS/DFS

**Statement**

`prerequisites[i] = [a,b]` means b before a. Can you finish all courses? Framing: can onboarding checklist modules be ordered?

**Approach**

Build adj + indegree; Kahn’s BFS topological sort; if processed < n ⇒ cycle.

**Complexity:** Time O(V+E), Space O(V+E)

### Kotlin

```kotlin
fun canFinish(numCourses: Int, prerequisites: Array<IntArray>): Boolean {
    val adj = List(numCourses) { mutableListOf<Int>() }
    val indeg = IntArray(numCourses)
    for (e in prerequisites) { adj[e[1]].add(e[0]); indeg[e[0]]++ }
    val q = ArrayDeque<Int>()
    for (i in indeg.indices) if (indeg[i] == 0) q.add(i)
    var seen = 0
    while (q.isNotEmpty()) {
        val u = q.removeFirst(); seen++
        for (v in adj[u]) if (--indeg[v] == 0) q.add(v)
    }
    return seen == numCourses
}
```

### Swift

```swift
func canFinish(_ numCourses: Int, _ prerequisites: [[Int]]) -> Bool {
    var adj = Array(repeating: [Int](), count: numCourses)
    var indeg = Array(repeating: 0, count: numCourses)
    for e in prerequisites { adj[e[1]].append(e[0]); indeg[e[0]] += 1 }
    var q: [Int] = []
    for i in 0..<numCourses where indeg[i] == 0 { q.append(i) }
    var seen = 0, head = 0
    while head < q.count {
        let u = q[head]; head += 1; seen += 1
        for v in adj[u] { indeg[v] -= 1; if indeg[v] == 0 { q.append(v) } }
    }
    return seen == numCourses
}
```

### Dart

```dart
import 'dart:collection';

bool canFinish(int numCourses, List<List<int>> prerequisites) {
  final adj = List.generate(numCourses, (_) => <int>[]);
  final indeg = List<int>.filled(numCourses, 0);
  for (final e in prerequisites) { adj[e[1]].add(e[0]); indeg[e[0]]++; }
  final q = Queue<int>();
  for (var i = 0; i < numCourses; i++) if (indeg[i] == 0) q.add(i);
  var seen = 0;
  while (q.isNotEmpty) {
    final u = q.removeFirst(); seen++;
    for (final v in adj[u]) if (--indeg[v] == 0) q.add(v);
  }
  return seen == numCourses;
}
```

### TypeScript

```typescript
function canFinish(numCourses: number, prerequisites: number[][]): boolean {
  const adj: number[][] = Array.from({ length: numCourses }, () => []);
  const indeg: number[] = Array(numCourses).fill(0);
  for (const [a, b] of prerequisites) { adj[b].push(a); indeg[a]++; }
  const q: number[] = [];
  for (let i = 0; i < numCourses; i++) if (indeg[i] === 0) q.push(i);
  let seen = 0, head = 0;
  while (head < q.length) {
    const u = q[head++]; seen++;
    for (const v of adj[u]) if (--indeg[v] === 0) q.push(v);
  }
  return seen === numCourses;
}
```

## Q24. Shortest Path in Unweighted Graph

**Topic:** Graphs BFS/DFS

**Statement**

Given adjacency list and `start`/`end`, return shortest hop distance or -1. Framing: fewest taps between settings screens.

**Approach**

BFS; first time reaching `end` is minimal hops. Mark seen on enqueue.

**Complexity:** Time O(V+E), Space O(V)

### Kotlin

```kotlin
fun shortestPath(g: Map<Int, List<Int>>, start: Int, end: Int): Int {
    if (start == end) return 0
    val seen = hashSetOf(start)
    val q = ArrayDeque(listOf(start))
    var dist = 0
    while (q.isNotEmpty()) {
        repeat(q.size) {
            val u = q.removeFirst()
            for (v in g[u].orEmpty()) {
                if (v == end) return dist + 1
                if (seen.add(v)) q.addLast(v)
            }
        }
        dist++
    }
    return -1
}
```

### Swift

```swift
func shortestPath(_ g: [Int: [Int]], _ start: Int, _ end: Int) -> Int {
    if start == end { return 0 }
    var seen: Set = [start]
    var q = [start]
    var head = 0, dist = 0
    while head < q.count {
        let size = q.count - head
        for _ in 0..<size {
            let u = q[head]; head += 1
            for v in g[u] ?? [] {
                if v == end { return dist + 1 }
                if seen.insert(v).inserted { q.append(v) }
            }
        }
        dist += 1
    }
    return -1
}
```

### Dart

```dart
int shortestPath(Map<int, List<int>> g, int start, int end) {
  if (start == end) return 0;
  final seen = <int>{start};
  final q = <int>[start];
  var head = 0, dist = 0;
  while (head < q.length) {
    final size = q.length - head;
    for (var i = 0; i < size; i++) {
      final u = q[head++];
      for (final v in g[u] ?? const <int>[]) {
        if (v == end) return dist + 1;
        if (seen.add(v)) q.add(v);
      }
    }
    dist++;
  }
  return -1;
}
```

### TypeScript

```typescript
function shortestPath(g: Map<number, number[]>, start: number, end: number): number {
  if (start === end) return 0;
  const seen = new Set<number>([start]);
  const q = [start];
  let head = 0, dist = 0;
  while (head < q.length) {
    const size = q.length - head;
    for (let i = 0; i < size; i++) {
      const u = q[head++];
      for (const v of g.get(u) ?? []) {
        if (v === end) return dist + 1;
        if (!seen.has(v)) { seen.add(v); q.push(v); }
      }
    }
    dist++;
  }
  return -1;
}
```

## Q25. Kth Largest Element

**Topic:** Heaps

**Statement**

Find the kth largest in an unsorted array. Framing: kth longest session in analytics.

**Approach**

Size-k min-heap of largest values; root is answer. Or QuickSelect average O(n).

**Complexity:** Time O(n log k), Space O(k)

### Kotlin

```kotlin
fun findKthLargest(nums: IntArray, k: Int): Int {
    val pq = java.util.PriorityQueue<Int>()
    for (x in nums) {
        pq.add(x)
        if (pq.size > k) pq.poll()
    }
    return pq.peek()
}
```

### Swift

```swift
// Min-heap via array for interview clarity
func findKthLargest(_ nums: [Int], _ k: Int) -> Int {
    var heap = [Int]()
    func siftUp(_ i: Int) {
        var i = i
        while i > 0 {
            let p = (i - 1) / 2
            if heap[p] <= heap[i] { break }
            heap.swapAt(p, i); i = p
        }
    }
    func siftDown(_ i: Int) {
        var i = i
        while true {
            var s = i
            let l = 2 * i + 1, r = l + 1
            if l < heap.count && heap[l] < heap[s] { s = l }
            if r < heap.count && heap[r] < heap[s] { s = r }
            if s == i { break }
            heap.swapAt(i, s); i = s
        }
    }
    for x in nums {
        if heap.count < k { heap.append(x); siftUp(heap.count - 1) }
        else if x > heap[0] { heap[0] = x; siftDown(0) }
    }
    return heap[0]
}
```

### Dart

```dart
// Min-heap via list for interview clarity
int findKthLargest(List<int> nums, int k) {
  final heap = <int>[];
  void swap(int a, int b) { final t = heap[a]; heap[a] = heap[b]; heap[b] = t; }
  void siftUp(int i) {
    while (i > 0) {
      final p = (i - 1) >> 1;
      if (heap[p] <= heap[i]) break;
      swap(p, i); i = p;
    }
  }
  void siftDown(int i) {
    while (true) {
      var s = i;
      final l = 2 * i + 1, r = l + 1;
      if (l < heap.length && heap[l] < heap[s]) s = l;
      if (r < heap.length && heap[r] < heap[s]) s = r;
      if (s == i) break;
      swap(i, s); i = s;
    }
  }
  for (final x in nums) {
    if (heap.length < k) { heap.add(x); siftUp(heap.length - 1); }
    else if (x > heap[0]) { heap[0] = x; siftDown(0); }
  }
  return heap[0];
}
```

### TypeScript

```typescript
// Min-heap via array for interview clarity
function findKthLargest(nums: number[], k: number): number {
  const heap: number[] = [];
  const swap = (a: number, b: number) => { [heap[a], heap[b]] = [heap[b], heap[a]]; };
  function siftUp(i: number): void {
    while (i > 0) {
      const p = (i - 1) >> 1;
      if (heap[p] <= heap[i]) break;
      swap(p, i); i = p;
    }
  }
  function siftDown(i: number): void {
    while (true) {
      let s = i;
      const l = 2 * i + 1, r = l + 1;
      if (l < heap.length && heap[l] < heap[s]) s = l;
      if (r < heap.length && heap[r] < heap[s]) s = r;
      if (s === i) break;
      swap(i, s); i = s;
    }
  }
  for (const x of nums) {
    if (heap.length < k) { heap.push(x); siftUp(heap.length - 1); }
    else if (x > heap[0]) { heap[0] = x; siftDown(0); }
  }
  return heap[0];
}
```

## Q26. Merge K Sorted Lists (Feed Merge)

**Topic:** Heaps

**Statement**

Merge k sorted linked lists. Framing: merge k sorted notification streams.

**Approach**

Min-heap of current heads keyed by value; pop, append, push next. The Dart/TS sketches below use **pairwise divide-and-conquer merge** (also correct; O(N log k) with different constants) when a stdlib heap is awkward.

**Complexity:** Time O(N log k), Space O(k) (heap) or O(1) extra beyond output for pairwise merge

### Kotlin

```kotlin
fun mergeKLists(lists: Array<ListNode?>): ListNode? {
    val pq = java.util.PriorityQueue<ListNode>(compareBy { it.`val` })
    for (head in lists) if (head != null) pq.add(head)
    val dummy = ListNode(0)
    var tail = dummy
    while (pq.isNotEmpty()) {
        val n = pq.poll()
        tail.next = n; tail = n
        n.next?.let { pq.add(it) }
    }
    return dummy.next
}
```

### Swift

```swift
// No stdlib heap: pairwise divide-and-conquer, like the Dart/TS sketches
func mergeKLists(_ lists: [ListNode?]) -> ListNode? {
    func merge(_ a: ListNode?, _ b: ListNode?) -> ListNode? {
        let d = ListNode(0)
        var t = d, p = a, q = b
        while let x = p, let y = q {
            if x.val <= y.val { t.next = x; p = x.next } else { t.next = y; q = y.next }
            t = t.next ?? t
        }
        t.next = p ?? q
        return d.next
    }
    if lists.isEmpty { return nil }
    var lists = lists
    var interval = 1
    while interval < lists.count {
        var i = 0
        while i + interval < lists.count {
            lists[i] = merge(lists[i], lists[i + interval])
            i += interval * 2
        }
        interval *= 2
    }
    return lists[0]
}
```

### Dart

```dart
ListNode? mergeKLists(List<ListNode?> lists) {
  // simple pairwise merge for sketch without package heap:
  ListNode? merge(ListNode? a, ListNode? b) {
    final d = ListNode(0); var t = d;
    var p = a, q = b;
    while (p != null && q != null) {
      if (p.val <= q.val) { t.next = p; p = p.next; }
      else { t.next = q; q = q.next; }
      t = t.next!;
    }
    t.next = p ?? q;
    return d.next;
  }
  if (lists.isEmpty) return null;
  var interval = 1;
  while (interval < lists.length) {
    for (var i = 0; i + interval < lists.length; i += interval * 2) {
      lists[i] = merge(lists[i], lists[i + interval]);
    }
    interval *= 2;
  }
  return lists[0];
}
```

### TypeScript

```typescript
function mergeKLists(lists: (ListNode | null)[]): ListNode | null {
  function merge(a: ListNode | null, b: ListNode | null): ListNode | null {
    const d = new ListNode(0); let t = d, p = a, q = b;
    while (p && q) {
      if (p.val <= q.val) { t.next = p; p = p.next; } else { t.next = q; q = q.next; }
      t = t.next!;
    }
    t.next = p ?? q; return d.next;
  }
  if (!lists.length) return null;
  let interval = 1;
  while (interval < lists.length) {
    for (let i = 0; i + interval < lists.length; i += interval * 2) {
      lists[i] = merge(lists[i], lists[i + interval]);
    }
    interval *= 2;
  }
  return lists[0];
}
```

## Q27. Meeting Rooms / Min Platforms (Heap)

**Topic:** Heaps

**Statement**

Given intervals `[start,end)`, return minimum number of concurrent rooms needed. Framing: min parallel download slots.

**Approach**

Sort by start; min-heap of end times; if next start >= earliest end, reuse; else new room.

**Complexity:** Time O(n log n), Space O(n)

### Kotlin

```kotlin
fun minMeetingRooms(intervals: Array<IntArray>): Int {
    if (intervals.isEmpty()) return 0
    intervals.sortBy { it[0] }
    val ends = java.util.PriorityQueue<Int>()
    ends.add(intervals[0][1])
    for (i in 1 until intervals.size) {
        if (intervals[i][0] >= ends.peek()) ends.poll()
        ends.add(intervals[i][1])
    }
    return ends.size
}
```

### Swift

```swift
func minMeetingRooms(_ intervals: [[Int]]) -> Int {
    let sorted = intervals.sorted { $0[0] < $1[0] }
    // Toy min-heap via sorted array — O(n) per push/pop → O(n² log n) worst.
    // Prefer a real binary heap (Chapter 12) for production / large n.
    var ends: [Int] = []
    func push(_ x: Int) { ends.append(x); ends.sort() }
    func popMin() { ends.removeFirst() }
    for (i, iv) in sorted.enumerated() {
        if i == 0 { push(iv[1]); continue }
        if let e = ends.first, iv[0] >= e { popMin() }
        push(iv[1])
    }
    return ends.count
}
```

### Dart

```dart
int minMeetingRooms(List<List<int>> intervals) {
  if (intervals.isEmpty) return 0;
  final sorted = [...intervals]..sort((a, b) => a[0].compareTo(b[0]));
  final ends = <int>[]; // binary min-heap of end times
  void push(int x) {
    ends.add(x);
    var i = ends.length - 1;
    while (i > 0) {
      final p = (i - 1) >> 1;
      if (ends[p] <= ends[i]) break;
      final t = ends[p]; ends[p] = ends[i]; ends[i] = t; i = p;
    }
  }
  void popMin() {
    final last = ends.removeLast();
    if (ends.isEmpty) return;
    ends[0] = last;
    var i = 0;
    while (true) {
      var s = i;
      final l = 2 * i + 1, r = l + 1;
      if (l < ends.length && ends[l] < ends[s]) s = l;
      if (r < ends.length && ends[r] < ends[s]) s = r;
      if (s == i) break;
      final t = ends[s]; ends[s] = ends[i]; ends[i] = t; i = s;
    }
  }
  push(sorted[0][1]);
  for (var i = 1; i < sorted.length; i++) {
    if (sorted[i][0] >= ends[0]) popMin();
    push(sorted[i][1]);
  }
  return ends.length;
}
```

### TypeScript

```typescript
function minMeetingRooms(intervals: number[][]): number {
  if (!intervals.length) return 0;
  const sorted = [...intervals].sort((a, b) => a[0] - b[0]);
  const ends: number[] = []; // binary min-heap of end times
  const swap = (a: number, b: number) => { [ends[a], ends[b]] = [ends[b], ends[a]]; };
  function push(x: number): void {
    ends.push(x);
    let i = ends.length - 1;
    while (i > 0) {
      const p = (i - 1) >> 1;
      if (ends[p] <= ends[i]) break;
      swap(p, i); i = p;
    }
  }
  function popMin(): void {
    const last = ends.pop()!;
    if (!ends.length) return;
    ends[0] = last;
    let i = 0;
    while (true) {
      let s = i;
      const l = 2 * i + 1, r = l + 1;
      if (l < ends.length && ends[l] < ends[s]) s = l;
      if (r < ends.length && ends[r] < ends[s]) s = r;
      if (s === i) break;
      swap(i, s); i = s;
    }
  }
  push(sorted[0][1]);
  for (let i = 1; i < sorted.length; i++) {
    if (sorted[i][0] >= ends[0]) popMin();
    push(sorted[i][1]);
  }
  return ends.length;
}
```

## Q28. Climbing Stairs

**Topic:** DP lite

**Statement**

Ways to climb `n` stairs taking 1 or 2 at a time. Framing: count onboarding paths with optional skip.

**Approach**

`dp[i] = dp[i-1] + dp[i-2]`; roll two variables.

**Complexity:** Time O(n), Space O(1)

### Kotlin

```kotlin
fun climbStairs(n: Int): Int {
    if (n <= 2) return n
    var a = 1; var b = 2
    for (i in 3..n) {
        val c = a + b; a = b; b = c
    }
    return b
}
```

### Swift

```swift
func climbStairs(_ n: Int) -> Int {
    if n <= 2 { return n }
    var a = 1, b = 2
    for _ in 3...n { (a, b) = (b, a + b) }
    return b
}
```

### Dart

```dart
int climbStairs(int n) {
  if (n <= 2) return n;
  var a = 1, b = 2;
  for (var i = 3; i <= n; i++) {
    final c = a + b; a = b; b = c;
  }
  return b;
}
```

### TypeScript

```typescript
function climbStairs(n: number): number {
  if (n <= 2) return n;
  let a = 1, b = 2;
  for (let i = 3; i <= n; i++) { const c = a + b; a = b; b = c; }
  return b;
}
```

## Q29. House Robber

**Topic:** DP lite

**Statement**

Max sum of non-adjacent houses. Framing: max score picking non-adjacent feed cards for a highlight reel.

**Approach**

`dp[i] = max(dp[i-1], dp[i-2] + nums[i])`.

**Complexity:** Time O(n), Space O(1)

### Kotlin

```kotlin
fun rob(nums: IntArray): Int {
    var prev2 = 0; var prev1 = 0
    for (x in nums) {
        val cur = maxOf(prev1, prev2 + x)
        prev2 = prev1; prev1 = cur
    }
    return prev1
}
```

### Swift

```swift
func rob(_ nums: [Int]) -> Int {
    var prev2 = 0, prev1 = 0
    for x in nums {
        let cur = max(prev1, prev2 + x)
        prev2 = prev1; prev1 = cur
    }
    return prev1
}
```

### Dart

```dart
int rob(List<int> nums) {
  var prev2 = 0, prev1 = 0;
  for (final x in nums) {
    final cur = prev1 > prev2 + x ? prev1 : prev2 + x;
    prev2 = prev1; prev1 = cur;
  }
  return prev1;
}
```

### TypeScript

```typescript
function rob(nums: number[]): number {
  let prev2 = 0, prev1 = 0;
  for (const x of nums) {
    const cur = Math.max(prev1, prev2 + x);
    prev2 = prev1; prev1 = cur;
  }
  return prev1;
}
```

## Q30. Coin Change

**Topic:** DP lite

**Statement**

Fewest coins to make `amount` from unlimited `coins`, or -1. Framing: fewest denomination taps in a wallet UI (when greedy fails).

**Approach**

`dp[x] = min over coin c of dp[x-c] + 1`; init `dp[0]=0`, else ∞.

**Complexity:** Time O(amount · |coins|), Space O(amount)

### Kotlin

```kotlin
fun coinChange(coins: IntArray, amount: Int): Int {
    val dp = IntArray(amount + 1) { amount + 1 }
    dp[0] = 0
    for (x in 1..amount) {
        for (c in coins) if (c <= x) dp[x] = minOf(dp[x], dp[x - c] + 1)
    }
    return if (dp[amount] > amount) -1 else dp[amount]
}
```

### Swift

```swift
func coinChange(_ coins: [Int], _ amount: Int) -> Int {
    var dp = Array(repeating: amount + 1, count: amount + 1)
    dp[0] = 0
    for x in stride(from: 1, through: amount, by: 1) {
        for c in coins where c <= x { dp[x] = min(dp[x], dp[x - c] + 1) }
    }
    return dp[amount] > amount ? -1 : dp[amount]
}
```

### Dart

```dart
int coinChange(List<int> coins, int amount) {
  final dp = List.filled(amount + 1, amount + 1);
  dp[0] = 0;
  for (var x = 1; x <= amount; x++) {
    for (final c in coins) {
      if (c <= x) dp[x] = dp[x] < dp[x - c] + 1 ? dp[x] : dp[x - c] + 1;
    }
  }
  return dp[amount] > amount ? -1 : dp[amount];
}
```

### TypeScript

```typescript
function coinChange(coins: number[], amount: number): number {
  const dp = Array(amount + 1).fill(amount + 1);
  dp[0] = 0;
  for (let x = 1; x <= amount; x++) {
    for (const c of coins) if (c <= x) dp[x] = Math.min(dp[x], dp[x - c] + 1);
  }
  return dp[amount] > amount ? -1 : dp[amount];
}
```

---

Previous: [Chapter 29 — Interview Questions, Mobile-Dev Focused — Q11–Q20](29-interview-questions-q11-q20.md) · Next: [Chapter 29 — Interview Questions, Mobile-Dev Focused — Q31–Q40](29-interview-questions-q31-q40.md) · Solutions: [`solutions/ch29`](../../solutions/ch29/README.md)
