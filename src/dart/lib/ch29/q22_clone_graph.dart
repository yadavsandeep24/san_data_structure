// Q22. Clone Graph
// Source: book/part-viii/29-interview-questions-q21-q30.md

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
