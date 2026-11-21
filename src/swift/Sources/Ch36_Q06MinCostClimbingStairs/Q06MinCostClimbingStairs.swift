// Q6. Min Cost Climbing Stairs (Cheapest Onboarding Path)
// Source: book/part-viii/36-graphs-dynamic-programming.md

func minCostClimbingStairs(_ cost: [Int]) -> Int {
    var twoBack = 0, oneBack = 0 // dp[i-2], dp[i-1]
    for i in stride(from: 2, through: cost.count, by: 1) {
        let cur = min(oneBack + cost[i - 1], twoBack + cost[i - 2])
        twoBack = oneBack
        oneBack = cur
    }
    return oneBack
}
