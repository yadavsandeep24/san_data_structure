// P1: Search insert position
// Source: solutions/ch21/README.md

function searchInsert(nums: number[], target: number): number {
  let lo = 0, hi = nums.length;
  while (lo < hi) {
    const mid = lo + ((hi - lo) >> 1);
    if (nums[mid] < target) lo = mid + 1;
    else hi = mid;
  }
  return lo;
}

export {};
