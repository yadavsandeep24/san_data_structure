// Q3. Longest Consecutive Sequence
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md

function longestConsecutive(nums: number[]): number {
  const set = new Set(nums);
  let best = 0;
  for (const x of set) {
    if (set.has(x - 1)) continue;
    let y = x, len = 1;
    while (set.has(y + 1)) { y++; len++; }
    best = Math.max(best, len);
  }
  return best;
}

export {};
