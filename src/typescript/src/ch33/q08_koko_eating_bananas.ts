// Q8. Koko Eating Bananas (Minimum Upload Rate)
// Source: book/part-viii/33-stacks-binary-search.md

function minEatingSpeed(piles: number[], h: number): number {
  let lo = 1, hi = Math.max(...piles);
  while (lo < hi) {
    const k = Math.floor((lo + hi) / 2);
    let hours = 0;
    for (const p of piles) hours += Math.ceil(p / k);
    if (hours <= h) hi = k; // feasible: try slower
    else lo = k + 1;
  }
  return lo;
}

export {};
