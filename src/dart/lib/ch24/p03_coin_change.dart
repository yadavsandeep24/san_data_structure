// P3: Coin change (fewest coins)
// Source: solutions/ch24/README.md

int coinChange(List<int> coins, int amount) {
  final inf = amount + 1;
  final dp = List<int>.filled(amount + 1, inf);
  dp[0] = 0;
  for (var x = 1; x <= amount; x++) {
    for (final c in coins) {
      if (c <= x && dp[x - c] + 1 < dp[x]) {
        dp[x] = dp[x - c] + 1;
      }
    }
  }
  return dp[amount] >= inf ? -1 : dp[amount];
}
