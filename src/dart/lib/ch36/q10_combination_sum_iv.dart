// Q10. Combination Sum IV (Ordered Top-Up Sequences)
// Source: book/part-viii/36-graphs-dynamic-programming.md

int combinationSum4(List<int> nums, int target) {
  final ways = List<int>.filled(target + 1, 0);
  ways[0] = 1;
  for (var t = 1; t <= target; t++) {
    for (final x in nums) {
      if (x <= t) ways[t] += ways[t - x]; // x is the last step
    }
  }
  return ways[target];
}
