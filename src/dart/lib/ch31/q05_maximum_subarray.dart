// Q5. Maximum Subarray (Best Trading Streak)
// Source: book/part-viii/31-arrays-hashing-matrix.md
import 'dart:math';

int maxSubArray(List<int> nums) {
  var best = nums[0];
  var cur = nums[0];
  for (var i = 1; i < nums.length; i++) {
    cur = max(nums[i], cur + nums[i]);
    best = max(best, cur);
  }
  return best;
}
