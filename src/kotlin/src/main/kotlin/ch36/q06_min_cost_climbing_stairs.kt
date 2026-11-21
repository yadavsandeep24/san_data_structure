// Q6. Min Cost Climbing Stairs (Cheapest Onboarding Path)
// Source: book/part-viii/36-graphs-dynamic-programming.md
package ch36.q06_min_cost_climbing_stairs

fun minCostClimbingStairs(cost: IntArray): Int {
    var twoBack = 0 // dp[i-2]
    var oneBack = 0 // dp[i-1]
    for (i in 2..cost.size) {
        val cur = minOf(oneBack + cost[i - 1], twoBack + cost[i - 2])
        twoBack = oneBack
        oneBack = cur
    }
    return oneBack
}
