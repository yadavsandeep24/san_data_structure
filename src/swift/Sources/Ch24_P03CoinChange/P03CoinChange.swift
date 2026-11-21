// P3: Coin change (fewest coins)
// Source: solutions/ch24/README.md

func coinChange(_ coins: [Int], _ amount: Int) -> Int {
    let inf = amount + 1
    var dp = Array(repeating: inf, count: amount + 1)
    dp[0] = 0
    if amount == 0 { return 0 }
    for x in 1...amount {
        for c in coins where c <= x {
            dp[x] = min(dp[x], dp[x - c] + 1)
        }
    }
    return dp[amount] >= inf ? -1 : dp[amount]
}
