// Q20. Find Peak Element
// Source: book/part-viii/29-interview-questions-q11-q20.md

int findPeakElement(List<int> nums) {
  var lo = 0, hi = nums.length - 1;
  while (lo < hi) {
    final mid = (lo + hi) >> 1;
    if (nums[mid] < nums[mid + 1]) lo = mid + 1; else hi = mid;
  }
  return lo;
}
