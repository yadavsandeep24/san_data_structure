// Q20. Currency Conversion Arbitrage (Bellman-Ford)
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md

function hasArbitrage(pairs: [string, string, number][]): boolean {
  const nodes = new Set<string>();
  for (const [a, b] of pairs) { nodes.add(a); nodes.add(b); }
  const list = [...nodes];
  const idx = new Map(list.map((c, i) => [c, i]));
  const n = list.length;
  const edges = pairs.map(([a, b, rate]) => [idx.get(a)!, idx.get(b)!, -Math.log(rate)] as const);
  const dist = Array(n).fill(0);
  for (let i = 0; i < n - 1; i++) {
    for (const [u, v, w] of edges) if (dist[v] > dist[u] + w) dist[v] = dist[u] + w;
  }
  for (const [u, v, w] of edges) if (dist[v] > dist[u] + w + 1e-12) return true;
  return false;
}

export {};
