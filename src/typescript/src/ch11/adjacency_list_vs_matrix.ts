// Adjacency list vs matrix
// Source: book/part-iii/11-graphs-intro.md

// Undirected: add both ways
const g = new Map<number, number[]>();
function addEdge(u: number, v: number): void {
  if (!g.has(u)) g.set(u, []);
  if (!g.has(v)) g.set(v, []);
  g.get(u)!.push(v);
  g.get(v)!.push(u);
}

export {};
