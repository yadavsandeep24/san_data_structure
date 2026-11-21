// Q6. Course Schedule II (Return Order)
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md

function findOrder(numCourses: number, prerequisites: number[][]): number[] {
  const g: number[][] = Array.from({ length: numCourses }, () => []);
  const indeg = Array(numCourses).fill(0);
  for (const [a, b] of prerequisites) {
    g[b].push(a);
    indeg[a]++;
  }
  const q: number[] = [];
  for (let i = 0; i < numCourses; i++) if (indeg[i] === 0) q.push(i);
  const order: number[] = [];
  while (q.length) {
    const u = q.shift()!;
    order.push(u);
    for (const v of g[u]) if (--indeg[v] === 0) q.push(v);
  }
  return order.length === numCourses ? order : [];
}

export {};
