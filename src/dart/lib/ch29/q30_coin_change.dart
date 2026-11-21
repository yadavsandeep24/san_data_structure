// Q30. Coin Change
// Source: book/part-viii/29-interview-questions-q21-q30.md

int coinChange(List<int> coins, int amount) {
  final dp = List.filled(amount + 1, amount + 1);
  dp[0] = 0;
  for (var x = 1; x <= amount; x++) {
    for (final c in coins) {
      if (c <= x) dp[x] = dp[x] < dp[x - c] + 1 ? dp[x] : dp[x - c] + 1;
    }
  }
  return dp[amount] > amount ? -1 : dp[amount];
}
