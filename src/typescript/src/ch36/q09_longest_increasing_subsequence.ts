// Q9. Longest Increasing Subsequence (Longest Rising Streak)
// Source: book/part-viii/36-graphs-dynamic-programming.md

function lengthOfLIS(nums: number[]): number {
  const tails: number[] = []; // tails[k] = smallest tail of an increasing run of length k+1
  for (const x of nums) {
    let lo = 0, hi = tails.length;
    while (lo < hi) {
      const mid = (lo + hi) >> 1;
      if (tails[mid] < x) lo = mid + 1;
      else hi = mid;
    }
    tails[lo] = x; // extends when lo === tails.length
  }
  return tails.length;
}

export {};
