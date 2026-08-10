# Chapter 20 — Graphs — Advanced Patterns

## Mobile motivation

Chapter 11 gave you BFS and DFS. Product graphs get richer: **app modules and feature flags have prerequisites** (you cannot enable Checkout until Cart is ready), **maps and CDNs care about shortest weighted paths**, and **offline sync merges “which devices share a cluster”** without rebuilding the whole graph every time.

This chapter covers three interview-and-product workhorses:

1. **Topological sort (Kahn)** — order work when edges mean “must finish before”
2. **Dijkstra** — shortest path on non-negative weighted graphs (min-heap)
3. **Union-Find (DSU)** — track connected components under unions, with path compression and union by rank

## Topological sort — Kahn’s algorithm

### Build / prerequisites analogy

Imagine a CI pipeline or a mobile feature-flag graph:

```text
Auth ──► Profile
  │
  └────► Cart ──► Checkout
```

Edges mean **“A must come before B”** (A is a prerequisite of B). A **topological order** is any linear order of nodes that respects every edge: Auth before Profile and Cart; Cart before Checkout. Cycles mean “impossible” — Auth requires Checkout which requires Auth.

### Kahn’s idea

1. Compute **in-degree** for every node (how many prerequisites still block it).
2. Put all nodes with in-degree `0` into a queue (ready to build).
3. Pop a ready node, append it to the order, and **decrement** in-degrees of its neighbors. When a neighbor’s in-degree hits `0`, enqueue it.
4. If you processed fewer than `V` nodes, a **cycle** exists.

Time O(V + E), space O(V + E).

```text
ready = { nodes with indegree 0 }
order = []
while ready not empty:
  u = ready.pop()
  order.append(u)
  for v in neighbors(u):
    indegree[v]--
    if indegree[v] == 0: ready.push(v)
if order.length < V: cycle / impossible
```

### Kotlin — Kahn sketch

```kotlin
fun topoSort(n: Int, edges: List<Pair<Int, Int>>): List<Int>? {
    val g = Array(n) { mutableListOf<Int>() }
    val indeg = IntArray(n)
    for ((u, v) in edges) {
        g[u].add(v)
        indeg[v]++
    }
    val q = ArrayDeque<Int>()
    for (i in 0 until n) if (indeg[i] == 0) q.add(i)
    val order = mutableListOf<Int>()
    while (q.isNotEmpty()) {
        val u = q.removeFirst()
        order.add(u)
        for (v in g[u]) {
            if (--indeg[v] == 0) q.add(v)
        }
    }
    return if (order.size == n) order else null
}
```

### Swift

```swift
func topoSort(_ n: Int, _ edges: [(Int, Int)]) -> [Int]? {
    var g = Array(repeating: [Int](), count: n)
    var indeg = Array(repeating: 0, count: n)
    for (u, v) in edges {
        g[u].append(v)
        indeg[v] += 1
    }
    var q = indeg.indices.filter { indeg[$0] == 0 }
    var order: [Int] = []
    var head = 0
    while head < q.count {
        let u = q[head]; head += 1
        order.append(u)
        for v in g[u] {
            indeg[v] -= 1
            if indeg[v] == 0 { q.append(v) }
        }
    }
    return order.count == n ? order : nil
}
```

### Dart

```dart
List<int>? topoSort(int n, List<(int, int)> edges) {
  final g = List.generate(n, (_) => <int>[]);
  final indeg = List.filled(n, 0);
  for (final (u, v) in edges) {
    g[u].add(v);
    indeg[v]++;
  }
  final q = <int>[for (var i = 0; i < n; i++) if (indeg[i] == 0) i];
  final order = <int>[];
  var head = 0;
  while (head < q.length) {
    final u = q[head++];
    order.add(u);
    for (final v in g[u]) {
      if (--indeg[v] == 0) q.add(v);
    }
  }
  return order.length == n ? order : null;
}
```

### TypeScript

```typescript
function topoSort(n: number, edges: [number, number][]): number[] | null {
  const g: number[][] = Array.from({ length: n }, () => []);
  const indeg = new Array(n).fill(0);
  for (const [u, v] of edges) {
    g[u].push(v);
    indeg[v]++;
  }
  const q: number[] = [];
  for (let i = 0; i < n; i++) if (indeg[i] === 0) q.push(i);
  const order: number[] = [];
  let head = 0;
  while (head < q.length) {
    const u = q[head++];
    order.push(u);
    for (const v of g[u]) {
      if (--indeg[v] === 0) q.push(v);
    }
  }
  return order.length === n ? order : null;
}
```

**Course schedule** is Kahn with a boolean: return whether a valid order exists (no cycle among `numCourses` and prerequisite pairs).

## Dijkstra — shortest path with a min-heap

BFS finds shortest paths when every edge costs **1**. When edges have **non-negative weights** (latency ms, kilometers, battery cost), use **Dijkstra**.

### Idea

Maintain `dist[v]` = best known distance from source `s`. Use a **min-heap** of `(distance, node)`. Always expand the unsettled node with the smallest distance. Relax outgoing edges: if `dist[u] + w(u,v) < dist[v]`, update and push.

```text
dist[s] = 0; others = ∞
pq.push(0, s)
while pq not empty:
  (d, u) = pq.pop()
  if d > dist[u]: continue   // stale heap entry
  for each edge u → v with weight w:
    if dist[u] + w < dist[v]:
      dist[v] = dist[u] + w
      pq.push(dist[v], v)
```

| Fact | Detail |
|------|--------|
| Requires | Non-negative weights (negative edges → Bellman-Ford / other) |
| Time (binary heap) | O((V + E) log V) typical with duplicate pushes |
| Space | O(V + E) |

**Network delay time:** graph of `n` nodes, directed weighted edges, source `k` — answer is `max(dist)` if all reachable, else `-1`.

### Kotlin (PriorityQueue)

```kotlin
fun networkDelayTime(times: Array<IntArray>, n: Int, k: Int): Int {
    val g = Array(n + 1) { mutableListOf<Pair<Int, Int>>() }
    for (t in times) g[t[0]].add(t[1] to t[2])
    val dist = IntArray(n + 1) { Int.MAX_VALUE / 4 }
    dist[k] = 0
    val pq = java.util.PriorityQueue(compareBy<Pair<Int, Int>> { it.first })
    pq.add(0 to k)
    while (pq.isNotEmpty()) {
        val (d, u) = pq.poll()
        if (d > dist[u]) continue
        for ((v, w) in g[u]) {
            if (d + w < dist[v]) {
                dist[v] = d + w
                pq.add(dist[v] to v)
            }
        }
    }
    val ans = dist.drop(1).maxOrNull()!!
    return if (ans >= Int.MAX_VALUE / 4) -1 else ans
}
```

### Swift (min-heap of pairs)

```swift
func networkDelayTime(_ times: [[Int]], _ n: Int, _ k: Int) -> Int {
    var g = Array(repeating: [(Int, Int)](), count: n + 1)
    for t in times { g[t[0]].append((t[1], t[2])) }
    var dist = Array(repeating: Int.max, count: n + 1)
    dist[k] = 0
    var heap = MinHeapPair()
    heap.push(0, k)
    while let (d, u) = heap.pop() {
        if d > dist[u] { continue }
        for (v, w) in g[u] where d + w < dist[v] {
            dist[v] = d + w
            heap.push(dist[v], v)
        }
    }
    let ans = dist.dropFirst().max()!
    return ans == Int.max ? -1 : ans
}
// MinHeapPair: same sift as Chapter 18, storing (dist, node)
```

### Dart

```dart
int networkDelayTime(List<List<int>> times, int n, int k) {
  final g = List.generate(n + 1, (_) => <(int, int)>[]);
  for (final t in times) {
    g[t[0]].add((t[1], t[2]));
  }
  final dist = List.filled(n + 1, 1 << 30);
  dist[k] = 0;
  final pq = HeapPriorityQueue<(int, int)>((a, b) => a.$1.compareTo(b.$1));
  pq.add((0, k));
  while (pq.isNotEmpty) {
    final (d, u) = pq.removeFirst();
    if (d > dist[u]) continue;
    for (final (v, w) in g[u]) {
      if (d + w < dist[v]) {
        dist[v] = d + w;
        pq.add((dist[v], v));
      }
    }
  }
  final ans = dist.skip(1).reduce((a, b) => a > b ? a : b);
  return ans >= (1 << 30) ? -1 : ans;
}
```

### TypeScript

```typescript
function networkDelayTime(times: number[][], n: number, k: number): number {
  const g: [number, number][][] = Array.from({ length: n + 1 }, () => []);
  for (const [u, v, w] of times) g[u].push([v, w]);
  const dist = Array(n + 1).fill(Infinity);
  dist[k] = 0;
  const heap = new MinHeap<[number, number]>((a, b) => a[0] - b[0]);
  heap.push([0, k]);
  while (heap.size) {
    const [d, u] = heap.pop()!;
    if (d > dist[u]) continue;
    for (const [v, w] of g[u]) {
      if (d + w < dist[v]) {
        dist[v] = d + w;
        heap.push([dist[v], v]);
      }
    }
  }
  let ans = 0;
  for (let i = 1; i <= n; i++) {
    if (dist[i] === Infinity) return -1;
    ans = Math.max(ans, dist[i]);
  }
  return ans;
}
```

**Stale entries:** binary heaps often allow duplicate node entries instead of decrease-key. Skipping when `d > dist[u]` is correct and simpler on mobile interview whiteboards.

## Union-Find (Disjoint Set Union)

### What it answers

“Are A and B in the same component?” and “merge these two sets” — repeatedly. Perfect for **number of connected components**, **redundant connection** (edge that creates a cycle), offline friend-circle clustering, and region merging in games.

### Structure

- `parent[i]` — parent of `i` (root points to itself)
- `rank[i]` or `size[i]` — tree height / size heuristic

**Find** with **path compression**: while walking to the root, point nodes at the root (or grandparent) so future finds are nearly O(1) amortized.

**Union by rank:** attach the shallower tree under the deeper root so trees stay short.

```text
find(x):
  if parent[x] != x: parent[x] = find(parent[x])
  return parent[x]

union(a, b):
  ra, rb = find(a), find(b)
  if ra == rb: return false   // already connected (redundant)
  if rank[ra] < rank[rb]: swap
  parent[rb] = ra
  if rank[ra] == rank[rb]: rank[ra]++
  return true
```

Amortized nearly O(α(n)) per op — inverse Ackermann, effectively constant.

### Kotlin

```kotlin
class UnionFind(n: Int) {
    private val parent = IntArray(n) { it }
    private val rank = IntArray(n)
    var components = n
        private set

    fun find(x: Int): Int {
        if (parent[x] != x) parent[x] = find(parent[x])
        return parent[x]
    }

    fun union(a: Int, b: Int): Boolean {
        var ra = find(a)
        var rb = find(b)
        if (ra == rb) return false
        if (rank[ra] < rank[rb]) {
            val t = ra; ra = rb; rb = t
        }
        parent[rb] = ra
        if (rank[ra] == rank[rb]) rank[ra]++
        components--
        return true
    }
}
```

### Swift

```swift
final class UnionFind {
    private var parent: [Int]
    private var rank: [Int]
    private(set) var components: Int
    init(_ n: Int) {
        parent = Array(0..<n)
        rank = Array(repeating: 0, count: n)
        components = n
    }
    func find(_ x: Int) -> Int {
        if parent[x] != x { parent[x] = find(parent[x]) }
        return parent[x]
    }
    @discardableResult
    func union(_ a: Int, _ b: Int) -> Bool {
        var ra = find(a), rb = find(b)
        if ra == rb { return false }
        if rank[ra] < rank[rb] { swap(&ra, &rb) }
        parent[rb] = ra
        if rank[ra] == rank[rb] { rank[ra] += 1 }
        components -= 1
        return true
    }
}
```

### Dart

```dart
class UnionFind {
  final List<int> parent;
  final List<int> rank;
  int components;
  UnionFind(int n)
      : parent = List.generate(n, (i) => i),
        rank = List.filled(n, 0),
        components = n;

  int find(int x) {
    if (parent[x] != x) parent[x] = find(parent[x]);
    return parent[x];
  }

  bool union(int a, int b) {
    var ra = find(a), rb = find(b);
    if (ra == rb) return false;
    if (rank[ra] < rank[rb]) {
      final t = ra;
      ra = rb;
      rb = t;
    }
    parent[rb] = ra;
    if (rank[ra] == rank[rb]) rank[ra]++;
    components--;
    return true;
  }
}
```

### TypeScript

```typescript
class UnionFind {
  parent: number[];
  rank: number[];
  components: number;
  constructor(n: number) {
    this.parent = Array.from({ length: n }, (_, i) => i);
    this.rank = Array(n).fill(0);
    this.components = n;
  }
  find(x: number): number {
    if (this.parent[x] !== x) this.parent[x] = this.find(this.parent[x]);
    return this.parent[x];
  }
  union(a: number, b: number): boolean {
    let ra = this.find(a), rb = this.find(b);
    if (ra === rb) return false;
    if (this.rank[ra] < this.rank[rb]) [ra, rb] = [rb, ra];
    this.parent[rb] = ra;
    if (this.rank[ra] === this.rank[rb]) this.rank[ra]++;
    this.components--;
    return true;
  }
}
```

**Connected components on an undirected graph:** start with `n` components; `union` each edge; answer is `uf.components`.

**Redundant connection:** for each edge in order, if `find(u) == find(v)` already, that edge is redundant; else `union`.

## When to use which

| Need | Tool |
|------|------|
| Order tasks / detect cycle in directed deps | Kahn topo |
| Shortest path, non-negative weights | Dijkstra + min-heap |
| Unweighted shortest path | BFS (Chapter 11) |
| Dynamic merges / “same group?” | Union-Find |
| Reachability flood | DFS/BFS |

## Platform bridges

| Platform | Graph-ish reality |
|----------|-------------------|
| **Android** | Module/feature dependency graphs; WorkManager constraints are topological in spirit |
| **iOS** | Deeplink / coordinator graphs; MapKit routing is library Dijkstra/A* |
| **Flutter** | Navigator / go_router stacks; isolate task graphs |
| **React Native** | Screen dependency + Metro module graph (build-time) |

## Common mistakes

1. Using Dijkstra with **negative** weights.
2. Forgetting to detect cycles in Kahn (`order.size < n`).
3. Union-Find without path compression — still correct but slower; interviews expect compression + rank/size.
4. Treating directed “prerequisite” edges as undirected when building the graph.
5. Not skipping stale Dijkstra heap entries (`d > dist[u]`).

## Self-Check

**20.1** In Kahn’s algorithm, what does in-degree `0` mean in the build/prerequisites analogy?

**20.2** Why must Dijkstra assume non-negative edge weights?

**20.3** What do path compression and union by rank each optimize?

**20.4** How do you detect a redundant undirected edge with Union-Find?

**20.5** Course schedule returns false — what graph property failed?

*(Answers: Appendix D.)*

## Practice

1. **Course schedule** — [solutions/ch20](../../solutions/ch20/README.md#p1-course-schedule)
2. **Network delay time (Dijkstra)** — [solutions/ch20](../../solutions/ch20/README.md#p2-network-delay-time)
3. **Number of connected components / redundant connection** — [solutions/ch20](../../solutions/ch20/README.md#p3-connected-components--redundant-connection)

Next: [Chapter 21 — Strings](21-strings.md) — anagrams, palindromes, and string cost realities across Kotlin, Swift, Dart, and TypeScript.
