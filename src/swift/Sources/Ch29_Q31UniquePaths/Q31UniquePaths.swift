// Q31. Unique Paths
// Source: book/part-viii/29-interview-questions-q31-q40.md

func uniquePaths(_ m: Int, _ n: Int) -> Int {
    var dp = Array(repeating: 1, count: n)
    for _ in 1..<m { for j in 1..<n { dp[j] += dp[j - 1] } }
    return dp[n - 1]
}
