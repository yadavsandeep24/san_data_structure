// Q29. House Robber
// Source: book/part-viii/29-interview-questions-q21-q30.md

int rob(List<int> nums) {
  var prev2 = 0, prev1 = 0;
  for (final x in nums) {
    final cur = prev1 > prev2 + x ? prev1 : prev2 + x;
    prev2 = prev1; prev1 = cur;
  }
  return prev1;
}
