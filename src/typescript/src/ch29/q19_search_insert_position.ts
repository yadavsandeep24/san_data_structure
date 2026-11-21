// Q19. Search Insert Position (Lower Bound)
// Source: book/part-viii/29-interview-questions-q11-q20.md

function searchInsert(nums: number[], target: number): number {
  let lo = 0, hi = nums.length;
  while (lo < hi) {
    const mid = (lo + hi) >> 1;
    if (nums[mid] < target) lo = mid + 1; else hi = mid;
  }
  return lo;
}

export {};
