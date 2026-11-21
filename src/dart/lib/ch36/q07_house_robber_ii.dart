// Q7. House Robber II (Circular Carousel Ad Slots)
// Source: book/part-viii/36-graphs-dynamic-programming.md
import 'dart:math';

int rob(List<int> nums) {
  if (nums.length == 1) return nums[0];
  int robLine(int from, int to) {
    var prev = 0, best = 0; // best up to i-2, best up to i-1
    for (var i = from; i <= to; i++) {
      final take = prev + nums[i];
      prev = best;
      best = max(best, take);
    }
    return best;
  }

  return max(robLine(0, nums.length - 2), robLine(1, nums.length - 1));
}
