// P2: First and last position
// Source: solutions/ch21/README.md

function searchRange(nums: number[], target: number): number[] {
  const lower = (): number => {
    let lo = 0, hi = nums.length;
    while (lo < hi) {
      const mid = lo + ((hi - lo) >> 1);
      if (nums[mid] < target) lo = mid + 1;
      else hi = mid;
    }
    return lo;
  };
  const upper = (): number => {
    let lo = 0, hi = nums.length;
    while (lo < hi) {
      const mid = lo + ((hi - lo) >> 1);
      if (nums[mid] <= target) lo = mid + 1;
      else hi = mid;
    }
    return lo;
  };
  const L = lower();
  if (L === nums.length || nums[L] !== target) return [-1, -1];
  return [L, upper() - 1];
}

export {};
