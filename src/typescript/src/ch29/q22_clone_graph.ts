// Q22. Clone Graph
// Source: book/part-viii/29-interview-questions-q21-q30.md

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

export {};
