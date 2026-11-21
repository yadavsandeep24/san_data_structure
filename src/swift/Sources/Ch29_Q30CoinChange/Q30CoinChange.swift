// Q30. Coin Change
// Source: book/part-viii/29-interview-questions-q21-q30.md

func coinChange(_ coins: [Int], _ amount: Int) -> Int {
    var dp = Array(repeating: amount + 1, count: amount + 1)
    dp[0] = 0
    for x in stride(from: 1, through: amount, by: 1) {
        for c in coins where c <= x { dp[x] = min(dp[x], dp[x - c] + 1) }
    }
    return dp[amount] > amount ? -1 : dp[amount]
}
