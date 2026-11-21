// Q6. Min Cost Climbing Stairs (Cheapest Onboarding Path)
// Source: book/part-viii/36-graphs-dynamic-programming.md

function minCostClimbingStairs(cost: number[]): number {
  let twoBack = 0, oneBack = 0; // dp[i-2], dp[i-1]
  for (let i = 2; i <= cost.length; i++) {
    const cur = Math.min(oneBack + cost[i - 1], twoBack + cost[i - 2]);
    twoBack = oneBack;
    oneBack = cur;
  }
  return oneBack;
}

export {};
