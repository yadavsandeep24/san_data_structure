// Binary search — the version that does not lie
// Source: book/part-vi/21-searching-sorting.md

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
