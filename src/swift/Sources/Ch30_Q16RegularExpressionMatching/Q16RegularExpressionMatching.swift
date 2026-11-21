// Q16. Regular Expression Matching
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md

func isMatch(_ s: String, _ p: String) -> Bool {
    let s = Array(s), p = Array(p)
    let m = s.count, n = p.count
    var dp = Array(repeating: Array(repeating: false, count: n + 1), count: m + 1)
    dp[0][0] = true
    for j in stride(from: 2, through: n, by: 1) where p[j - 1] == "*" && dp[0][j - 2] {
        dp[0][j] = true
    }
    for i in stride(from: 1, through: m, by: 1) {
        for j in stride(from: 1, through: n, by: 1) {
            if p[j - 1] == "*" {
                dp[i][j] = dp[i][j - 2] ||
                    ((p[j - 2] == "." || p[j - 2] == s[i - 1]) && dp[i - 1][j])
            } else if p[j - 1] == "." || p[j - 1] == s[i - 1] {
                dp[i][j] = dp[i - 1][j - 1]
            }
        }
    }
    return dp[m][n]
}
