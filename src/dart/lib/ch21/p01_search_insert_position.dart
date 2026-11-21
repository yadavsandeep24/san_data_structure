// P1: Search insert position
// Source: solutions/ch21/README.md

int searchInsert(List<int> nums, int target) {
  var lo = 0, hi = nums.length;
  while (lo < hi) {
    final mid = lo + (hi - lo) ~/ 2;
    if (nums[mid] < target) {
      lo = mid + 1;
    } else {
      hi = mid;
    }
  }
  return lo;
}
