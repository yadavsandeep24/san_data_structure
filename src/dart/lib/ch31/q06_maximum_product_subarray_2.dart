// Q6 — Maximum product subarray (Swift / Dart)
// Source: solutions/ch31/README.md
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
