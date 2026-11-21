// P2: Clone graph
// Source: solutions/ch11/README.md

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
