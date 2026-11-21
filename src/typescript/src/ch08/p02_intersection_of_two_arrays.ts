// P2: Intersection of two arrays
// Source: solutions/ch08/README.md

function intersection(a: number[], b: number[]): number[] {
  const setA = new Set(a);
  const out = new Set<number>();
  for (const x of b) if (setA.has(x)) out.add(x);
  return [...out];
}

export {};
