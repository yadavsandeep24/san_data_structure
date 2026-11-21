// Q24. Shortest Path in Unweighted Graph
// Source: book/part-viii/29-interview-questions-q21-q30.md

function shortestPath(g: Map<number, number[]>, start: number, end: number): number {
  if (start === end) return 0;
  const seen = new Set<number>([start]);
  const q = [start];
  let head = 0, dist = 0;
  while (head < q.length) {
    const size = q.length - head;
    for (let i = 0; i < size; i++) {
      const u = q[head++];
      for (const v of g.get(u) ?? []) {
        if (v === end) return dist + 1;
        if (!seen.has(v)) { seen.add(v); q.push(v); }
      }
    }
    dist++;
  }
  return -1;
}

export {};
