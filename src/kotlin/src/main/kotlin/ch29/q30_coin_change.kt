// Q30. Coin Change
// Source: book/part-viii/29-interview-questions-q21-q30.md
package ch29.q30_coin_change

fun coinChange(coins: IntArray, amount: Int): Int {
    val dp = IntArray(amount + 1) { amount + 1 }
    dp[0] = 0
    for (x in 1..amount) {
        for (c in coins) if (c <= x) dp[x] = minOf(dp[x], dp[x - c] + 1)
    }
    return if (dp[amount] > amount) -1 else dp[amount]
}
