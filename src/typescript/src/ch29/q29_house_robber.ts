// Q29. House Robber
// Source: book/part-viii/29-interview-questions-q21-q30.md

function rob(nums: number[]): number {
  let prev2 = 0, prev1 = 0;
  for (const x of nums) {
    const cur = Math.max(prev1, prev2 + x);
    prev2 = prev1; prev1 = cur;
  }
  return prev1;
}

export {};
