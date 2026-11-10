# Chapter 11 — Graphs Intro

## Mobile motivation

A social app is a **graph**: users are vertices; follows/friends are edges. So is screen navigation — each route is a node; push/present/deeplink transitions are edges. Offline maps, dependency graphs between modules, and “who liked this post” are graphs too.

Trees (Chapters 9–10) are graphs with a stricter shape: in graph theory, a *tree* is connected, undirected, and acyclic. **App trees** (UI, file, JSON) are usually **rooted and directed** (parent → children). Real product *graphs* allow **cycles** (A follows B follows A), **directions** (one-way follow), and multiple components (isolated friend circles). This chapter gives representations and the two traversals you will use constantly: **BFS** and **DFS**.

## Vertices and edges

| Term | Meaning | Mobile example |
|------|---------|----------------|
| **Vertex / node** | An entity | User ID, screen route name |
| **Edge** | A link between vertices | Follow, “can navigate to” |
| **Directed** | Edge has direction `u → v` | Follow graph, deeplink flow |
| **Undirected** | Edge is bidirectional | Mutual friends, Bluetooth mesh sketch |
| **Weighted** | Edge has cost | Travel time (advanced — Chapter 20) |
| **Degree** | Number of incident edges | Follower count (directed: in/out degree) |
| **Path** | Sequence of edges | Navigation stack trail |
| **Cycle** | Path that returns to start | A→B→A follows |
| **Connected component** | Maximal connected subgraph | Cluster of mutual friends; “provinces” |

```text
Undirected:    1 — 2 — 3        Directed:    1 → 2 → 3
                \ /                            ↑_____|
                 4
```

## Adjacency list vs matrix

### Adjacency list

For each vertex, store a list (or set) of neighbors. Sparse graphs (most social / navigation graphs) love this.

**Kotlin**

```kotlin
// Undirected: add both ways
val g = HashMap<Int, MutableList<Int>>()
fun addEdge(u: Int, v: Int) {
    g.getOrPut(u) { mutableListOf() }.add(v)
    g.getOrPut(v) { mutableListOf() }.add(u)
}
```

**Swift**

```swift
// Undirected: add both ways
var g: [Int: [Int]] = [:]
func addEdge(_ u: Int, _ v: Int) {
    g[u, default: []].append(v)
    g[v, default: []].append(u)
}
```

**Dart**

```dart
// Undirected: add both ways
final g = <int, List<int>>{};
void addEdge(int u, int v) {
  g.putIfAbsent(u, () => []).add(v);
  g.putIfAbsent(v, () => []).add(u);
}
```

**TypeScript**

```typescript
// Undirected: add both ways
const g = new Map<number, number[]>();
function addEdge(u: number, v: number): void {
  if (!g.has(u)) g.set(u, []);
  if (!g.has(v)) g.set(v, []);
  g.get(u)!.push(v);
  g.get(v)!.push(u);
}
```

### Adjacency matrix

`matrix[i][j] = 1` (or weight) if edge `i → j`. Dense graphs and fast edge-existence checks; uses Θ(V²) memory — painful for millions of users.

| Representation | Space | Edge check | Iterate neighbors | Best for |
|----------------|-------|------------|-------------------|----------|
| **Adj. list** | O(V + E) | O(deg) or O(1) with sets | O(deg) | Sparse (default mobile) |
| **Adj. matrix** | O(V²) | O(1) | O(V) | Small dense graphs |

**Rule of thumb:** Prefer adjacency lists unless V is tiny and you need O(1) “is there an edge?”.

## BFS and DFS

Both visit every reachable vertex from a source (on an undirected connected graph: the whole component).

| | **BFS** (Breadth-First) | **DFS** (Depth-First) |
|--|-------------------------|------------------------|
| Data structure | Queue | Stack / recursion |
| Visits | Level by level | Plunge down paths |
| Classic use | Shortest path in **unweighted** graphs; “nearest screens” | Cycle detect; topological ideas; flood fill |
| Time | O(V + E) | O(V + E) |
| Extra space | O(V) | O(V) |

### BFS template

**Kotlin**

```kotlin
fun bfs(graph: Map<Int, List<Int>>, start: Int): List<Int> {
    val seen = hashSetOf(start)
    val q = ArrayDeque(listOf(start))
    val order = mutableListOf<Int>()
    while (q.isNotEmpty()) {
        val u = q.removeFirst()
        order += u
        for (v in graph[u].orEmpty()) {
            if (seen.add(v)) q.addLast(v)   // mark when enqueued
        }
    }
    return order
}
```

**Swift**

```swift
func bfs(_ graph: [Int: [Int]], start: Int) -> [Int] {
    var seen: Set = [start]
    var q = [start]
    var order: [Int] = []
    var head = 0
    while head < q.count {
        let u = q[head]; head += 1
        order.append(u)
        for v in graph[u] ?? [] where seen.insert(v).inserted {
            q.append(v)                    // mark when enqueued
        }
    }
    return order
}
```

**Dart**

```dart
import 'dart:collection';

List<int> bfs(Map<int, List<int>> graph, int start) {
  final seen = <int>{start};
  final q = Queue<int>()..add(start);
  final order = <int>[];
  while (q.isNotEmpty) {
    final u = q.removeFirst();
    order.add(u);
    for (final v in graph[u] ?? const <int>[]) {
      if (seen.add(v)) q.addLast(v); // mark when enqueued
    }
  }
  return order;
}
```

**TypeScript**

```typescript
function bfs(graph: Map<number, number[]>, start: number): number[] {
  const seen = new Set<number>([start]);
  const q: number[] = [start];
  const order: number[] = [];
  let head = 0;
  while (head < q.length) {
    const u = q[head++];
    order.push(u);
    for (const v of graph.get(u) ?? []) {
      if (!seen.has(v)) {
        seen.add(v);
        q.push(v);
      }
    }
  }
  return order;
}
```

Mark **seen when enqueued** (not when dequeued) to avoid duplicate queue entries.

### DFS template

**Kotlin**

```kotlin
fun dfs(graph: Map<Int, List<Int>>, start: Int): List<Int> {
    val seen = HashSet<Int>()
    val order = mutableListOf<Int>()
    fun go(u: Int) {
        seen += u
        order += u
        for (v in graph[u].orEmpty()) if (v !in seen) go(v)
    }
    go(start)
    return order
}
```

**Swift**

```swift
func dfs(_ graph: [Int: [Int]], start: Int) -> [Int] {
    var seen = Set<Int>()
    var order: [Int] = []
    func go(_ u: Int) {
        seen.insert(u)
        order.append(u)
        for v in graph[u] ?? [] where !seen.contains(v) {
            go(v)
        }
    }
    go(start)
    return order
}
```

**Dart**

```dart
List<int> dfs(Map<int, List<int>> graph, int start) {
  final seen = <int>{};
  final order = <int>[];
  void go(int u) {
    seen.add(u);
    order.add(u);
    for (final v in graph[u] ?? const <int>[]) {
      if (!seen.contains(v)) go(v);
    }
  }
  go(start);
  return order;
}
```

**TypeScript**

```typescript
function dfs(graph: Map<number, number[]>, start: number): number[] {
  const seen = new Set<number>();
  const order: number[] = [];
  function go(u: number): void {
    seen.add(u);
    order.push(u);
    for (const v of graph.get(u) ?? []) {
      if (!seen.has(v)) go(v);
    }
  }
  go(start);
  return order;
}
```

## Social graph

```text
alice → bob → cara
  ↓       ↖︎
 dana      (cara → bob)  // cycle possible in directed follows
```

Queries:

- **Followers of bob** — incoming edges (store reverse adj list too).
- **Mutual friends** — intersection of neighbor sets (Chapter 8).
- **Provinces / circles** — connected components on an undirected “friends” graph.

## Screen navigation as a graph

Treat each route as a vertex: `Home`, `Product`, `Cart`, `Checkout`, `Login`. Edges are legal transitions (including deeplinks).

**Kotlin**

```kotlin
val nav = mapOf(
    "Home" to listOf("Product", "Login", "Cart"),
    "Product" to listOf("Cart", "Home"),
    "Cart" to listOf("Checkout", "Home"),
    "Checkout" to listOf("Home"),
    "Login" to listOf("Home"),
)
```

**Swift**

```swift
let nav: [String: [String]] = [
    "Home": ["Product", "Login", "Cart"],
    "Product": ["Cart", "Home"],
    "Cart": ["Checkout", "Home"],
    "Checkout": ["Home"],
    "Login": ["Home"],
]
```

**Dart**

```dart
final nav = <String, List<String>>{
  'Home': ['Product', 'Login', 'Cart'],
  'Product': ['Cart', 'Home'],
  'Cart': ['Checkout', 'Home'],
  'Checkout': ['Home'],
  'Login': ['Home'],
};
```

**TypeScript**

```typescript
const nav = new Map<string, string[]>([
  ['Home', ['Product', 'Login', 'Cart']],
  ['Product', ['Cart', 'Home']],
  ['Cart', ['Checkout', 'Home']],
  ['Checkout', ['Home']],
  ['Login', ['Home']],
]);
```

- **BFS from Home** — minimum hops to Checkout (unweighted “how many screens?”).
- **DFS** — explore whether a deeplink target is reachable without presenting an illegal stack.
- Real nav stacks are richer (arguments, results, auth gates) — the graph is the skeleton for reachability reasoning.

## Platform bridges

| Platform | Graph-shaped systems |
|----------|----------------------|
| **Android** | Navigation component nav graph (XML/Compose); Task/back stack; `PackageManager` intent resolution; social/follower sync. |
| **iOS** | UINavigationController / coordinator flows; universal links routing tables; CloudKit share graphs. |
| **Flutter** | GoRouter / Navigator 2 routes + redirects; widget rebuild dependency ideas; isolate message topologies. |
| **React Native** | React Navigation route config; deep linking paths; Redux dependency; bridge module graph. |

## Complexity at a glance

| Problem | Approach | Time | Space |
|---------|----------|------|-------|
| Traverse all reachable | BFS or DFS | O(V + E) | O(V) |
| Connected components | Multi-source DFS/BFS | O(V + E) | O(V) |
| Shortest path (unweighted) | BFS distances | O(V + E) | O(V) |
| Clone graph | BFS/DFS + map old→new | O(V + E) | O(V) |

## Pattern: number of provinces (connected components)

Given an undirected graph (often as adjacency matrix `isConnected[i][j]`), count components.

**Kotlin**

```kotlin
fun findCircleNum(isConnected: Array<IntArray>): Int {
    val n = isConnected.size
    val seen = BooleanArray(n)
    var provinces = 0
    fun dfs(u: Int) {
        seen[u] = true
        for (v in 0 until n) {
            if (isConnected[u][v] == 1 && !seen[v]) dfs(v)
        }
    }
    for (i in 0 until n) {
        if (!seen[i]) {
            provinces++
            dfs(i)
        }
    }
    return provinces
}
```

**Swift**

```swift
func findCircleNum(_ isConnected: [[Int]]) -> Int {
    let n = isConnected.count
    var seen = Array(repeating: false, count: n)
    var count = 0
    func dfs(_ u: Int) {
        seen[u] = true
        for v in 0..<n where isConnected[u][v] == 1 && !seen[v] { dfs(v) }
    }
    for i in 0..<n where !seen[i] {
        count += 1
        dfs(i)
    }
    return count
}
```

**Dart**

```dart
int findCircleNum(List<List<int>> isConnected) {
  final n = isConnected.length;
  final seen = List<bool>.filled(n, false);
  var count = 0;
  void dfs(int u) {
    seen[u] = true;
    for (var v = 0; v < n; v++) {
      if (isConnected[u][v] == 1 && !seen[v]) dfs(v);
    }
  }
  for (var i = 0; i < n; i++) {
    if (!seen[i]) {
      count++;
      dfs(i);
    }
  }
  return count;
}
```

**TypeScript**

```typescript
function findCircleNum(isConnected: number[][]): number {
  const n = isConnected.length;
  const seen = Array(n).fill(false);
  let count = 0;
  const dfs = (u: number) => {
    seen[u] = true;
    for (let v = 0; v < n; v++) {
      if (isConnected[u][v] === 1 && !seen[v]) dfs(v);
    }
  };
  for (let i = 0; i < n; i++) {
    if (!seen[i]) {
      count++;
      dfs(i);
    }
  }
  return count;
}
```

## Pattern: shortest path in unweighted graph

BFS layers = distance. Store `dist[v]` or parent pointers to reconstruct the path.

**Kotlin**

```kotlin
fun shortestHops(g: Map<String, List<String>>, src: String, dst: String): Int? {
    if (src == dst) return 0
    val dist = hashMapOf(src to 0)
    val q = ArrayDeque(listOf(src))
    while (q.isNotEmpty()) {
        val u = q.removeFirst()
        for (v in g[u].orEmpty()) {
            if (v !in dist) {
                dist[v] = dist.getValue(u) + 1
                if (v == dst) return dist[v]
                q.addLast(v)
            }
        }
    }
    return null // unreachable
}
```

**Swift**

```swift
func shortestHops(_ g: [String: [String]], _ src: String, _ dst: String) -> Int? {
    if src == dst { return 0 }
    var dist = [src: 0]
    var q = [src]
    var head = 0
    while head < q.count {
        let u = q[head]; head += 1
        let du = dist[u] ?? 0
        for v in g[u] ?? [] where dist[v] == nil {
            dist[v] = du + 1
            if v == dst { return du + 1 }
            q.append(v)
        }
    }
    return nil // unreachable
}
```

**Dart**

```dart
import 'dart:collection';

int? shortestHops(Map<String, List<String>> g, String src, String dst) {
  if (src == dst) return 0;
  final dist = <String, int>{src: 0};
  final q = Queue<String>()..add(src);
  while (q.isNotEmpty) {
    final u = q.removeFirst();
    for (final v in g[u] ?? const []) {
      if (!dist.containsKey(v)) {
        dist[v] = dist[u]! + 1;
        if (v == dst) return dist[v];
        q.addLast(v);
      }
    }
  }
  return null; // unreachable
}
```

**TypeScript**

```typescript
function shortestHops(g: Map<string, string[]>, src: string, dst: string): number | null {
  if (src === dst) return 0;
  const dist = new Map<string, number>([[src, 0]]);
  const q = [src];
  let head = 0;
  while (head < q.length) {
    const u = q[head++];
    for (const v of g.get(u) ?? []) {
      if (!dist.has(v)) {
        dist.set(v, dist.get(u)! + 1);
        if (v === dst) return dist.get(v)!;
        q.push(v);
      }
    }
  }
  return null; // unreachable
}
```

## Common mistakes

1. **Forgetting to mark visited** — infinite loops on cycles (social graphs always have them).
2. **Marking visited too late in BFS** — quadratic queue blowups.
3. **Using DFS for shortest path** in unweighted graphs — wrong; use BFS.
4. **Adjacency matrix for huge V** — memory explosion on mobile.
5. **One-way edge when mutual friendship was intended** — model directed vs undirected explicitly.
6. **Recursing DFS on huge components** — prefer iterative stack on mobile.

## Self-Check

**11.1** How does a tree differ from a general undirected graph?

**11.2** When is an adjacency list preferable to a matrix?

**11.3** Why does BFS find shortest paths in unweighted graphs?

**11.4** Give a mobile example of a directed graph.

**11.5** What is the time complexity of BFS in terms of V and E?

*(Answers: Appendix D.)*

## Practice

1. **Number of provinces** (connected components) — [solutions/ch11](../../solutions/ch11/README.md#p1-number-of-provinces)
2. **Clone graph** — [solutions/ch11](../../solutions/ch11/README.md#p2-clone-graph)
3. **Shortest path in unweighted graph (BFS)** — [solutions/ch11](../../solutions/ch11/README.md#p3-shortest-path-unweighted)

Back: [Chapter 10 — Trees Practical](10-trees-practical.md) · Next: [Chapter 12 — Caching Strategies](../part-iv/12-caching-strategies.md)
