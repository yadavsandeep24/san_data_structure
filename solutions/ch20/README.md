# Chapter 20 — Model Solutions

Model solutions for Chapter 20 practice problems. Each names the pattern, states complexity, lists edge cases, and adds a short mobile note.

Problems are defined in [`book/part-vi/20-graphs-advanced.md`](../../book/part-vi/20-graphs-advanced.md).

---

## P1: Course schedule

### Approach

Model courses `0..numCourses-1` as nodes; each prerequisite `[a, b]` means edge `b → a` (“b before a”). Run **Kahn’s topological sort**: queue all zero in-degree nodes, peel layers, decrement neighbors. If you process all courses, scheduling is possible; otherwise a cycle exists → `false`.

### Complexity

- Time: O(V + E) with V = numCourses, E = prerequisites
- Space: O(V + E)

### Edge cases

- No prerequisites → `true`
- Self-loop or mutual pair → `false`
- Disconnected components (multiple zero in-degree starts)
- Single course

### Mobile note

Feature-flag / module init order on app launch. Keep graphs small on device; large dependency resolution belongs in CI. Never run heavy graph builds on the UI thread at cold start without measuring.

### Kotlin

```kotlin
fun canFinish(numCourses: Int, prerequisites: Array<IntArray>): Boolean {
    val g = Array(numCourses) { mutableListOf<Int>() }
    val indeg = IntArray(numCourses)
    for (p in prerequisites) {
        val a = p[0]
        val b = p[1]
        g[b].add(a)
        indeg[a]++
    }
    val q = ArrayDeque<Int>()
    for (i in 0 until numCourses) if (indeg[i] == 0) q.add(i)
    var seen = 0
    while (q.isNotEmpty()) {
        val u = q.removeFirst()
        seen++
        for (v in g[u]) if (--indeg[v] == 0) q.add(v)
    }
    return seen == numCourses
}
```

### Swift

```swift
func canFinish(_ numCourses: Int, _ prerequisites: [[Int]]) -> Bool {
    var g = Array(repeating: [Int](), count: numCourses)
    var indeg = Array(repeating: 0, count: numCourses)
    for p in prerequisites {
        let a = p[0], b = p[1]
        g[b].append(a)
        indeg[a] += 1
    }
    var q = indeg.indices.filter { indeg[$0] == 0 }
    var head = 0, seen = 0
    while head < q.count {
        let u = q[head]; head += 1
        seen += 1
        for v in g[u] {
            indeg[v] -= 1
            if indeg[v] == 0 { q.append(v) }
        }
    }
    return seen == numCourses
}
```

### Dart

```dart
bool canFinish(int numCourses, List<List<int>> prerequisites) {
  final g = List.generate(numCourses, (_) => <int>[]);
  final indeg = List.filled(numCourses, 0);
  for (final p in prerequisites) {
    final a = p[0], b = p[1];
    g[b].add(a);
    indeg[a]++;
  }
  final q = <int>[for (var i = 0; i < numCourses; i++) if (indeg[i] == 0) i];
  var head = 0, seen = 0;
  while (head < q.length) {
    final u = q[head++];
    seen++;
    for (final v in g[u]) {
      if (--indeg[v] == 0) q.add(v);
    }
  }
  return seen == numCourses;
}
```

### TypeScript

```typescript
function canFinish(numCourses: number, prerequisites: number[][]): boolean {
  const g: number[][] = Array.from({ length: numCourses }, () => []);
  const indeg = new Array(numCourses).fill(0);
  for (const [a, b] of prerequisites) {
    g[b].push(a);
    indeg[a]++;
  }
  const q: number[] = [];
  for (let i = 0; i < numCourses; i++) if (indeg[i] === 0) q.push(i);
  let head = 0, seen = 0;
  while (head < q.length) {
    const u = q[head++];
    seen++;
    for (const v of g[u]) {
      if (--indeg[v] === 0) q.push(v);
    }
  }
  return seen === numCourses;
}
```

---

## P2: Network delay time

### Approach

**Dijkstra** from source `k` on a directed weighted graph. Adjacency list of `(neighbor, weight)`. Min-heap of `(dist, node)`; relax edges; skip stale heap entries when popped distance `> dist[u]`. Answer is the maximum finite distance among nodes `1..n`; if any node remains unreachable, return `-1`.

### Complexity

- Time: O((V + E) log V) with binary heap and duplicate pushes
- Space: O(V + E)

### Edge cases

- Single node, no edges → `0`
- Unreachable node → `-1`
- Multiple edges / parallel paths — keep minimum
- Zero-weight edges OK; negative weights not allowed for Dijkstra

### Mobile note

Models “time until all devices get a config push” or CDN fan-out latency sketches. Prefer server-side for large graphs; on device keep V small. Do not block UI while running Dijkstra on thousands of nodes.

### Kotlin

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
    var ans = 0
    for (i in 1..n) {
        if (dist[i] >= Int.MAX_VALUE / 4) return -1
        ans = maxOf(ans, dist[i])
    }
    return ans
}
```

### Swift

```swift
func networkDelayTime(_ times: [[Int]], _ n: Int, _ k: Int) -> Int {
    var g = Array(repeating: [(Int, Int)](), count: n + 1)
    for t in times { g[t[0]].append((t[1], t[2])) }
    var dist = Array(repeating: Int.max / 4, count: n + 1)
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
    var ans = 0
    for i in 1...n {
        if dist[i] >= Int.max / 4 { return -1 }
        ans = max(ans, dist[i])
    }
    return ans
}

struct MinHeapPair {
    private var a: [(Int, Int)] = []
    mutating func push(_ d: Int, _ u: Int) {
        a.append((d, u)); siftUp(a.count - 1)
    }
    mutating func pop() -> (Int, Int)? {
        guard let first = a.first else { return nil }
        a[0] = a.last!; a.removeLast()
        if !a.isEmpty { siftDown(0) }
        return first
    }
    private mutating func siftUp(_ i: Int) {
        var i = i
        while i > 0 {
            let p = (i - 1) / 2
            if a[i].0 >= a[p].0 { break }
            a.swapAt(i, p); i = p
        }
    }
    private mutating func siftDown(_ i: Int) {
        var i = i
        while true {
            var best = i
            let l = 2 * i + 1, r = l + 1
            if l < a.count && a[l].0 < a[best].0 { best = l }
            if r < a.count && a[r].0 < a[best].0 { best = r }
            if best == i { break }
            a.swapAt(i, best); i = best
        }
    }
}
```

### Dart

```dart
import 'package:collection/collection.dart';

int networkDelayTime(List<List<int>> times, int n, int k) {
  final g = List.generate(n + 1, (_) => <(int, int)>[]);
  for (final t in times) {
    g[t[0]].add((t[1], t[2]));
  }
  const inf = 1 << 30;
  final dist = List.filled(n + 1, inf);
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
  var ans = 0;
  for (var i = 1; i <= n; i++) {
    if (dist[i] >= inf) return -1;
    if (dist[i] > ans) ans = dist[i];
  }
  return ans;
}
```

### TypeScript

```typescript
class MinHeapPair {
  private a: [number, number][] = [];
  get size() { return this.a.length; }
  push(d: number, u: number) {
    this.a.push([d, u]);
    this.siftUp(this.a.length - 1);
  }
  pop(): [number, number] | undefined {
    if (!this.a.length) return undefined;
    const top = this.a[0];
    const last = this.a.pop()!;
    if (this.a.length) {
      this.a[0] = last;
      this.siftDown(0);
    }
    return top;
  }
  private siftUp(i: number) {
    const a = this.a;
    while (i > 0) {
      const p = (i - 1) >> 1;
      if (a[i][0] >= a[p][0]) break;
      [a[i], a[p]] = [a[p], a[i]];
      i = p;
    }
  }
  private siftDown(i: number) {
    const a = this.a;
    for (;;) {
      let best = i;
      const l = i * 2 + 1, r = l + 1;
      if (l < a.length && a[l][0] < a[best][0]) best = l;
      if (r < a.length && a[r][0] < a[best][0]) best = r;
      if (best === i) break;
      [a[i], a[best]] = [a[best], a[i]];
      i = best;
    }
  }
}

function networkDelayTime(times: number[][], n: number, k: number): number {
  const g: [number, number][][] = Array.from({ length: n + 1 }, () => []);
  for (const [u, v, w] of times) g[u].push([v, w]);
  const dist = Array(n + 1).fill(Infinity);
  dist[k] = 0;
  const heap = new MinHeapPair();
  heap.push(0, k);
  while (heap.size) {
    const [d, u] = heap.pop()!;
    if (d > dist[u]) continue;
    for (const [v, w] of g[u]) {
      if (d + w < dist[v]) {
        dist[v] = d + w;
        heap.push(dist[v], v);
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

---

## P3: Connected components / redundant connection

### Approach

**Union-Find** with path compression and union by rank.

**Connected components:** start with `n` components; for each undirected edge, `union(u, v)` (0-based or 1-based consistently). Final answer is `uf.components`.

**Redundant connection:** process edges in order; if `find(u) == find(v)` before union, that edge closes a cycle — return it; else `union`.

### Complexity

- Time: nearly O(n + m · α(n))
- Space: O(n)

### Edge cases

- No edges → `n` components
- Already connected graph → first cycle-making edge is redundant
- Duplicate edges
- Nodes numbered `1..n` vs `0..n-1`

### Mobile note

Offline device clustering, merge of local conflict graphs, “same account across installs” sketches. Prefer DSU over repeated DFS when the edge stream is dynamic. Keep `n` bounded in memory on device.

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

fun countComponents(n: Int, edges: Array<IntArray>): Int {
    val uf = UnionFind(n)
    for (e in edges) uf.union(e[0], e[1])
    return uf.components
}

fun findRedundantConnection(edges: Array<IntArray>): IntArray {
    val uf = UnionFind(edges.size + 1) // nodes 1..n
    for (e in edges) {
        if (!uf.union(e[0], e[1])) return e
    }
    return intArrayOf()
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

func countComponents(_ n: Int, _ edges: [[Int]]) -> Int {
    let uf = UnionFind(n)
    for e in edges { uf.union(e[0], e[1]) }
    return uf.components
}

func findRedundantConnection(_ edges: [[Int]]) -> [Int] {
    let uf = UnionFind(edges.count + 1)
    for e in edges {
        if !uf.union(e[0], e[1]) { return e }
    }
    return []
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

int countComponents(int n, List<List<int>> edges) {
  final uf = UnionFind(n);
  for (final e in edges) {
    uf.union(e[0], e[1]);
  }
  return uf.components;
}

List<int> findRedundantConnection(List<List<int>> edges) {
  final uf = UnionFind(edges.length + 1);
  for (final e in edges) {
    if (!uf.union(e[0], e[1])) return e;
  }
  return [];
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

function countComponents(n: number, edges: number[][]): number {
  const uf = new UnionFind(n);
  for (const [u, v] of edges) uf.union(u, v);
  return uf.components;
}

function findRedundantConnection(edges: number[][]): number[] {
  const uf = new UnionFind(edges.length + 1);
  for (const e of edges) {
    if (!uf.union(e[0], e[1])) return e;
  }
  return [];
}
```
