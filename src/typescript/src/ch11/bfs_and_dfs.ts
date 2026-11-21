// BFS and DFS
// Source: book/part-iii/11-graphs-intro.md

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

export {};
