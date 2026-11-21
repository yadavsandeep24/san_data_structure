// P3: Shortest path unweighted
// Source: solutions/ch11/README.md

function shortestPath(
  graph: Map<string, string[]>,
  src: string,
  dst: string,
): { dist: number; path: string[] } | null {
  if (src === dst) return { dist: 0, path: [src] };
  const parent = new Map<string, string | null>([[src, null]]);
  const q: string[] = [src];
  let head = 0;
  while (head < q.length) {
    const u = q[head++];
    for (const v of graph.get(u) ?? []) {
      if (parent.has(v)) continue;
      parent.set(v, u);
      if (v === dst) {
        const path: string[] = [];
        for (let cur: string | null = dst; cur !== null; cur = parent.get(cur) ?? null) {
          path.push(cur);
        }
        path.reverse();
        return { dist: path.length - 1, path };
      }
      q.push(v);
    }
  }
  return null;
}

export {};
