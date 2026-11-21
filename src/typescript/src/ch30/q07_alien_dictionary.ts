// Q7. Alien Dictionary (Harder Graph Variant)
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md

function alienOrder(words: string[]): string {
  const adj = new Map<string, Set<string>>();
  const indeg = new Map<string, number>();
  for (const w of words) for (const c of w) {
    if (!adj.has(c)) adj.set(c, new Set());
    if (!indeg.has(c)) indeg.set(c, 0);
  }
  for (let i = 0; i < words.length - 1; i++) {
    const a = words[i], b = words[i + 1];
    if (a.length > b.length && a.startsWith(b)) return "";
    const n = Math.min(a.length, b.length);
    for (let j = 0; j < n; j++) {
      if (a[j] !== b[j]) {
        if (!adj.get(a[j])!.has(b[j])) {
          adj.get(a[j])!.add(b[j]);
          indeg.set(b[j], (indeg.get(b[j]) ?? 0) + 1);
        }
        break;
      }
    }
  }
  const q: string[] = [];
  for (const [c, d] of indeg) if (d === 0) q.push(c);
  let out = "";
  while (q.length) {
    const u = q.shift()!;
    out += u;
    for (const v of adj.get(u)!) {
      indeg.set(v, indeg.get(v)! - 1);
      if (indeg.get(v) === 0) q.push(v);
    }
  }
  return out.length === indeg.size ? out : "";
}

export {};
