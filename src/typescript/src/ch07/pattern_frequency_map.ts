// Pattern: frequency map
// Source: book/part-iii/07-hash-tables.md

function freq(s: string): Map<string, number> {
  const m = new Map<string, number>();
  for (const c of s) m.set(c, (m.get(c) ?? 0) + 1); // code points
  return m;
}

export {};
