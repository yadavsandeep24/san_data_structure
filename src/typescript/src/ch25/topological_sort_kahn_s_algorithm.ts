// Topological sort — Kahn’s algorithm
// Source: book/part-vii/25-graphs-advanced.md

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

export {};
