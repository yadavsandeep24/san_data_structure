# Chapter 11 — Model Solutions

## P1: Number of provinces

### Approach

Treat the city/friend matrix as an undirected graph: `isConnected[i][j] == 1` means an edge. Scan all vertices; each time you find an unvisited vertex, increment the province count and DFS/BFS to mark its entire component visited.

### Complexity

- Time: O(n²) for matrix input (equivalent to O(V + E) with E up to n²)
- Space: O(n) for visited (+ recursion stack)

### Edge cases

- `n == 1` → 1 province
- Fully connected → 1
- Identity matrix only → n provinces
- Asymmetry bugs in input — assume symmetric undirected matrix as stated

### Mobile note

Same algorithm as counting isolated sync cohorts or Bluetooth mesh clusters from an adjacency dump — keep the matrix off-heap / compact if n grows.

### Kotlin

```kotlin
fun findCircleNum(isConnected: Array<IntArray>): Int {
    val n = isConnected.size
    val seen = BooleanArray(n)
    var count = 0
    fun dfs(u: Int) {
        seen[u] = true
        for (v in 0 until n) {
            if (isConnected[u][v] == 1 && !seen[v]) dfs(v)
        }
    }
    for (i in 0 until n) {
        if (!seen[i]) {
            count++
            dfs(i)
        }
    }
    return count
}
```

### Swift

```swift
func findCircleNum(_ isConnected: [[Int]]) -> Int {
    let n = isConnected.count
    var seen = Array(repeating: false, count: n)
    var count = 0
    func dfs(_ u: Int) {
        seen[u] = true
        for v in 0..<n where isConnected[u][v] == 1 && !seen[v] {
            dfs(v)
        }
    }
    for i in 0..<n where !seen[i] {
        count += 1
        dfs(i)
    }
    return count
}
```

### Dart

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

### TypeScript

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

---

## P2: Clone graph

### Approach

Each original node has a `val` and `neighbors: List<Node>`. Use a map `old → new`. DFS or BFS: if a node was already cloned, return the clone; otherwise create it, store in the map, then recurse/iterate neighbors and append cloned neighbors. The map breaks cycles.

### Complexity

- Time: O(V + E)
- Space: O(V)

### Edge cases

- Empty / null input → null
- Single node with no neighbors
- Cycles and mutual edges — map prevents infinite recursion
- Disconnected graphs — problem usually gives one node in a connected component; clone from that node only

### Mobile note

Cloning a navigation subgraph or offline social neighborhood for a preview screen — never mutate the source of truth while the UI holds the clone.

### Kotlin

```kotlin
class Node(var `val`: Int) {
    var neighbors: ArrayList<Node?> = ArrayList()
}

fun cloneGraph(node: Node?): Node? {
    if (node == null) return null
    val map = HashMap<Node, Node>()
    fun dfs(n: Node): Node {
        map[n]?.let { return it }
        val copy = Node(n.`val`)
        map[n] = copy
        for (nb in n.neighbors) {
            if (nb != null) copy.neighbors.add(dfs(nb))
        }
        return copy
    }
    return dfs(node)
}
```

### Swift

```swift
final class Node {
    var val: Int
    var neighbors: [Node]
    init(_ val: Int) { self.val = val; self.neighbors = [] }
}

func cloneGraph(_ node: Node?) -> Node? {
    guard let node else { return nil }
    var map = [ObjectIdentifier: Node]()
    func dfs(_ n: Node) -> Node {
        let id = ObjectIdentifier(n)
        if let c = map[id] { return c }
        let copy = Node(n.val)
        map[id] = copy
        copy.neighbors = n.neighbors.map { dfs($0) }
        return copy
    }
    return dfs(node)
}
```

### Dart

```dart
class Node {
  Node(this.val, [List<Node>? neighbors]) : neighbors = neighbors ?? [];
  int val;
  List<Node> neighbors;
}

Node? cloneGraph(Node? node) {
  if (node == null) return null;
  final map = <Node, Node>{};
  Node dfs(Node n) {
    final existing = map[n];
    if (existing != null) return existing;
    final copy = Node(n.val);
    map[n] = copy;
    for (final nb in n.neighbors) {
      copy.neighbors.add(dfs(nb));
    }
    return copy;
  }
  return dfs(node);
}
```

### TypeScript

```typescript
class GraphNode {
  val: number;
  neighbors: GraphNode[];
  constructor(val = 0, neighbors: GraphNode[] = []) {
    this.val = val;
    this.neighbors = neighbors;
  }
}

function cloneGraph(node: GraphNode | null): GraphNode | null {
  if (!node) return null;
  const map = new Map<GraphNode, GraphNode>();
  const dfs = (n: GraphNode): GraphNode => {
    const cached = map.get(n);
    if (cached) return cached;
    const copy = new GraphNode(n.val);
    map.set(n, copy);
    copy.neighbors = n.neighbors.map(dfs);
    return copy;
  };
  return dfs(node);
}
```

---

## P3: Shortest path unweighted

### Approach

BFS from the source. First time you reach the target, the hop count is minimal. Record `dist` or `parent` pointers to reconstruct the path. Mark visited when enqueueing.

### Complexity

- Time: O(V + E)
- Space: O(V)

### Edge cases

- `src == dst` → distance 0, path `[src]`
- Unreachable → null / empty
- Disconnected components
- Undirected: ensure edges stored both ways
- Multiple equal-length shortest paths — BFS returns one; any is valid unless tie-break specified

### Mobile note

“Minimum screens to Checkout from Home” or “minimum friend hops to this profile” — same BFS. Do not use DFS for hop counts.

### Kotlin

```kotlin
fun shortestPath(
    graph: Map<String, List<String>>,
    src: String,
    dst: String,
): Pair<Int, List<String>>? {
    if (src == dst) return 0 to listOf(src)
    val parent = HashMap<String, String?>()
    parent[src] = null
    val q = ArrayDeque<String>()
    q.addLast(src)
    while (q.isNotEmpty()) {
        val u = q.removeFirst()
        for (v in graph[u].orEmpty()) {
            if (v in parent) continue
            parent[v] = u
            if (v == dst) {
                val path = ArrayDeque<String>()
                var cur: String? = dst
                while (cur != null) {
                    path.addFirst(cur)
                    cur = parent[cur]
                }
                return (path.size - 1) to path.toList()
            }
            q.addLast(v)
        }
    }
    return null
}
```

### Swift

```swift
func shortestPath(
    _ graph: [String: [String]],
    src: String,
    dst: String
) -> (dist: Int, path: [String])? {
    if src == dst { return (0, [src]) }
    var parent: [String: String?] = [src: nil]
    var q = [src]
    var head = 0
    while head < q.count {
        let u = q[head]; head += 1
        for v in graph[u] ?? [] where parent[v] == nil {
            parent[v] = u
            if v == dst {
                var path = [String]()
                var cur: String? = dst
                while let c = cur {
                    path.append(c)
                    cur = parent[c] ?? nil
                }
                path.reverse()
                return (path.count - 1, path)
            }
            q.append(v)
        }
    }
    return nil
}
```

### Dart

```dart
import 'dart:collection';

({int dist, List<String> path})? shortestPath(
  Map<String, List<String>> graph,
  String src,
  String dst,
) {
  if (src == dst) return (dist: 0, path: [src]);
  final parent = <String, String?>{src: null};
  final q = Queue<String>()..add(src);
  while (q.isNotEmpty) {
    final u = q.removeFirst();
    for (final v in graph[u] ?? const []) {
      if (parent.containsKey(v)) continue;
      parent[v] = u;
      if (v == dst) {
        final path = <String>[];
        String? cur = dst;
        while (cur != null) {
          path.add(cur);
          cur = parent[cur];
        }
        return (dist: path.length - 1, path: path.reversed.toList());
      }
      q.addLast(v);
    }
  }
  return null;
}
```

### TypeScript

```typescript
function shortestPath(
  graph: Map<string, string[]>,
  src: string,
  dst: string,
): { dist: number; path: string[] } | null {
  if (src === dst) return { dist: 0, path: [src] };
  const parent = new Map<string, string | null>([[src, null]]);
  const q: string[] = [src];
  let head = 0;
  while (head < q.length) {
    const u = q[head++];
    for (const v of graph.get(u) ?? []) {
      if (parent.has(v)) continue;
      parent.set(v, u);
      if (v === dst) {
        const path: string[] = [];
        for (let cur: string | null = dst; cur !== null; cur = parent.get(cur) ?? null) {
          path.push(cur);
        }
        path.reverse();
        return { dist: path.length - 1, path };
      }
      q.push(v);
    }
  }
  return null;
}
```
