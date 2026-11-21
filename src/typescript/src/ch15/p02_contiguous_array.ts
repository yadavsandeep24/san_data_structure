// P2: Contiguous array (equal 0s and 1s)
// Source: solutions/ch15/README.md

function findMaxLength(a: number[]): number {
  const first = new Map<number, number>([[0, -1]]);
  let prefix = 0;
  let best = 0;
  for (let i = 0; i < a.length; i++) {
    prefix += a[i] === 1 ? 1 : -1;
    const f = first.get(prefix);
    if (f !== undefined) best = Math.max(best, i - f);
    else first.set(prefix, i);
  }
  return best;
}

export {};
