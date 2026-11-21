// P2: Clone graph
// Source: solutions/ch11/README.md

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

export {};
