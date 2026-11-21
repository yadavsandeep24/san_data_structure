// Pattern: longest consecutive sequence
// Source: book/part-iii/08-sets.md

function longestConsecutive(nums: number[]): number {
  const set = new Set(nums);
  let best = 0;
  for (const x of set) {
    if (set.has(x - 1)) continue;
    let y = x;
    let len = 1;
    while (set.has(y + 1)) {
      y++;
      len++;
    }
    best = Math.max(best, len);
  }
  return best;
}

export {};
