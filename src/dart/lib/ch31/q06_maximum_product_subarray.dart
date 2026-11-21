// Q6. Maximum Product Subarray (Compounded Multiplier Streak)
// Source: book/part-viii/31-arrays-hashing-matrix.md
import 'dart:math';

int maxProduct(List<int> nums) {
  var hi = nums[0], lo = nums[0], best = nums[0];
  for (final x in nums.skip(1)) {
    final a = hi * x, b = lo * x;
    hi = max(x, max(a, b));
    lo = min(x, min(a, b));
    best = max(best, hi);
  }
  return best;
}
