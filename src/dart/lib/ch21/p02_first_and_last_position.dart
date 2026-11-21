// P2: First and last position
// Source: solutions/ch21/README.md

List<int> searchRange(List<int> nums, int target) {
  int lower() {
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

  int upper() {
    var lo = 0, hi = nums.length;
    while (lo < hi) {
      final mid = lo + (hi - lo) ~/ 2;
      if (nums[mid] <= target) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
    return lo;
  }

  final L = lower();
  if (L == nums.length || nums[L] != target) return [-1, -1];
  return [L, upper() - 1];
}
