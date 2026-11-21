// Q5. Maximum Subarray (Best Trading Streak)
// Source: book/part-viii/31-arrays-hashing-matrix.md

function maxSubArray(nums: number[]): number {
  let best = nums[0];
  let cur = nums[0];
  for (let i = 1; i < nums.length; i++) {
    cur = Math.max(nums[i], cur + nums[i]);
    best = Math.max(best, cur);
  }
  return best;
}

export {};
