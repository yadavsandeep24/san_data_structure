// P3: Coin change (fewest coins)
// Source: solutions/ch24/README.md

function coinChange(coins: number[], amount: number): number {
  const inf = amount + 1;
  const dp = Array(amount + 1).fill(inf);
  dp[0] = 0;
  for (let x = 1; x <= amount; x++) {
    for (const c of coins) {
      if (c <= x) dp[x] = Math.min(dp[x], dp[x - c] + 1);
    }
  }
  return dp[amount] >= inf ? -1 : dp[amount];
}

export {};
