// P1: Maximum average subarray
// Source: solutions/ch14/README.md

function findMaxAverage(nums: number[], k: number): number {
  let sum = 0;
  for (let i = 0; i < k; i++) sum += nums[i];
  let best = sum;
  for (let r = k; r < nums.length; r++) {
    sum += nums[r] - nums[r - k];
    best = Math.max(best, sum);
  }
  return best / k;
}

export {};
