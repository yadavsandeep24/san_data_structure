// P3: Fruit into baskets (at most two kinds)
// Source: solutions/ch14/README.md

function totalFruit(types: number[]): number {
  const count = new Map<number, number>();
  let left = 0;
  let best = 0;
  for (let right = 0; right < types.length; right++) {
    count.set(types[right], (count.get(types[right]) ?? 0) + 1);
    while (count.size > 2) {
      const t = types[left];
      const c = count.get(t)! - 1;
      if (c === 0) count.delete(t);
      else count.set(t, c);
      left++;
    }
    best = Math.max(best, right - left + 1);
  }
  return best;
}

export {};
