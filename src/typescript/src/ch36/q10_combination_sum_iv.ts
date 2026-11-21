// Q10. Combination Sum IV (Ordered Top-Up Sequences)
// Source: book/part-viii/36-graphs-dynamic-programming.md

function combinationSum4(nums: number[], target: number): bigint {
  const ways = new Array<bigint>(target + 1).fill(0n); // bigint: counts pass 2^53 fast
  ways[0] = 1n;
  for (let t = 1; t <= target; t++) {
    for (const x of nums) if (x <= t) ways[t] += ways[t - x]; // x is the last step
  }
  return ways[target];
}

export {};
