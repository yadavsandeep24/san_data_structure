// P2: House robber
// Source: solutions/ch24/README.md

int rob(List<int> nums) {
  var prev2 = 0, prev1 = 0;
  for (final x in nums) {
    final cur = prev1 > prev2 + x ? prev1 : prev2 + x;
    prev2 = prev1;
    prev1 = cur;
  }
  return prev1;
}
