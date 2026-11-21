// Set algebra: union, intersection, difference
// Source: book/part-iii/08-sets.md

const a = new Set([1, 2, 3]);
const b = new Set([2, 3, 4]);
const union = new Set([...a, ...b]);                 // 1,2,3,4
const inter = new Set([...a].filter((x) => b.has(x))); // 2,3
const diff = new Set([...a].filter((x) => !b.has(x))); // 1

function intersection<T>(a: Set<T>, b: Set<T>): Set<T> {
  const out = new Set<T>();
  for (const x of a) if (b.has(x)) out.add(x);
  return out;
}

export {};
