// Q9. Minimum Size Subarray Sum (Shortest Run to Reach a Spend Goal)
// Source: book/part-viii/32-two-pointers-windows-intervals.md
import 'dart:math';

int minSubArrayLen(int target, List<int> nums) {
  var left = 0;
  var sum = 0;
  int? best;
  for (var right = 0; right < nums.length; right++) {
    sum += nums[right];
    while (sum >= target) {
      best = min(best ?? right - left + 1, right - left + 1);
      sum -= nums[left++];
    }
  }
  return best ?? 0;
}
