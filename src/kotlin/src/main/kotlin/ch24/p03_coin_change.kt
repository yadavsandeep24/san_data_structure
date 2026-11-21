// P3: Coin change (fewest coins)
// Source: solutions/ch24/README.md
package ch24.p03_coin_change

fun coinChange(coins: IntArray, amount: Int): Int {
    val inf = amount + 1
    val dp = IntArray(amount + 1) { inf }
    dp[0] = 0
    for (x in 1..amount) {
        for (c in coins) {
            if (c <= x) dp[x] = minOf(dp[x], dp[x - c] + 1)
        }
    }
    return if (dp[amount] >= inf) -1 else dp[amount]
}
