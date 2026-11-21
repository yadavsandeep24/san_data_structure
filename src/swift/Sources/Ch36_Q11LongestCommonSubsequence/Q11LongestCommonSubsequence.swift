// Q11. Longest Common Subsequence (Diffing Two Lists)
// Source: book/part-viii/36-graphs-dynamic-programming.md

func longestCommonSubsequence(_ a: String, _ b: String) -> Int {
    let a = Array(a), b = Array(b)
    var dp = [Int](repeating: 0, count: b.count + 1) // row i-1, overwritten into row i
    for i in stride(from: 1, through: a.count, by: 1) {
        var diag = 0 // dp[i-1][j-1]
        for j in stride(from: 1, through: b.count, by: 1) {
            let up = dp[j] // dp[i-1][j]
            dp[j] = a[i - 1] == b[j - 1] ? diag + 1 : max(up, dp[j - 1])
            diag = up
        }
    }
    return dp[b.count]
}
