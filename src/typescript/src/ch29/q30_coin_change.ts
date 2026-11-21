// Q30. Coin Change
// Source: book/part-viii/29-interview-questions-q21-q30.md

function coinChange(coins: number[], amount: number): number {
  const dp = Array(amount + 1).fill(amount + 1);
  dp[0] = 0;
  for (let x = 1; x <= amount; x++) {
    for (const c of coins) if (c <= x) dp[x] = Math.min(dp[x], dp[x - c] + 1);
  }
  return dp[amount] > amount ? -1 : dp[amount];
}

export {};
