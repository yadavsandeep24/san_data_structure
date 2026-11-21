// Q14. Target Sum (Signed Ledger Adjustments)
// Source: book/part-viii/36-graphs-dynamic-programming.md

function findTargetSumWays(nums: number[], target: number): number {
  const total = nums.reduce((a, b) => a + b, 0);
  if (Math.abs(target) > total || (total + target) % 2 !== 0) return 0;
  const want = (total + target) / 2; // sum of the '+' group
  const ways = new Array<number>(want + 1).fill(0);
  ways[0] = 1;
  for (const x of nums) {
    for (let s = want; s >= x; s--) ways[s] += ways[s - x]; // 0/1 knapsack, backwards
  }
  return ways[want];
}

export {};
