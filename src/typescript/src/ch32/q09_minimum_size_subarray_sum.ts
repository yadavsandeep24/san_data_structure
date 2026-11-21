// Q9. Minimum Size Subarray Sum (Shortest Run to Reach a Spend Goal)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

function minSubArrayLen(target: number, nums: number[]): number {
  let left = 0;
  let sum = 0;
  let best = Infinity;
  for (let right = 0; right < nums.length; right++) {
    sum += nums[right];
    while (sum >= target) {
      best = Math.min(best, right - left + 1);
      sum -= nums[left++];
    }
  }
  return best === Infinity ? 0 : best;
}

export {};
