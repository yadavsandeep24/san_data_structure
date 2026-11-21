// Q14. Target Sum (Signed Ledger Adjustments)
// Source: book/part-viii/36-graphs-dynamic-programming.md

int findTargetSumWays(List<int> nums, int target) {
  final total = nums.fold(0, (a, b) => a + b);
  if (target.abs() > total || (total + target) % 2 != 0) return 0;
  final want = (total + target) ~/ 2; // sum of the '+' group
  final ways = List<int>.filled(want + 1, 0);
  ways[0] = 1;
  for (final x in nums) {
    for (var s = want; s >= x; s--) {
      ways[s] += ways[s - x]; // 0/1 knapsack, backwards
    }
  }
  return ways[want];
}
