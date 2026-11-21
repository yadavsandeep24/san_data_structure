// Q18. Parallel Courses or Minimum Semesters
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md

function minimumSemesters(n: number, relations: number[][]): number {
  const g: number[][] = Array.from({ length: n + 1 }, () => []);
  const indeg = Array(n + 1).fill(0);
  for (const [a, b] of relations) { g[a].push(b); indeg[b]++; }
  const q: number[] = [];
  for (let i = 1; i <= n; i++) if (indeg[i] === 0) q.push(i);
  let sem = 0, taken = 0;
  while (q.length) {
    sem++;
    const size = q.length;
    for (let i = 0; i < size; i++) {
      const u = q.shift()!;
      taken++;
      for (const v of g[u]) if (--indeg[v] === 0) q.push(v);
    }
  }
  return taken === n ? sem : -1;
}

export {};
