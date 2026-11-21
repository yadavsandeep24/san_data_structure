// Pattern: shortest path in unweighted graph
// Source: book/part-iii/11-graphs-intro.md

function shortestHops(g: Map<string, string[]>, src: string, dst: string): number | null {
  if (src === dst) return 0;
  const dist = new Map<string, number>([[src, 0]]);
  const q = [src];
  let head = 0;
  while (head < q.length) {
    const u = q[head++];
    for (const v of g.get(u) ?? []) {
      if (!dist.has(v)) {
        dist.set(v, dist.get(u)! + 1);
        if (v === dst) return dist.get(v)!;
        q.push(v);
      }
    }
  }
  return null; // unreachable
}

export {};
