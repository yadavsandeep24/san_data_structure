// Q19. Search Insert Position (Lower Bound)
// Source: book/part-viii/29-interview-questions-q11-q20.md

int searchInsert(List<int> nums, int target) {
  var lo = 0, hi = nums.length;
  while (lo < hi) {
    final mid = (lo + hi) >> 1;
    if (nums[mid] < target) lo = mid + 1; else hi = mid;
  }
  return lo;
}
