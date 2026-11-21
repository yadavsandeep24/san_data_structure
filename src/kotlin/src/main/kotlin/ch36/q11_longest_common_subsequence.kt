// Q11. Longest Common Subsequence (Diffing Two Lists)
// Source: book/part-viii/36-graphs-dynamic-programming.md
package ch36.q11_longest_common_subsequence

fun longestCommonSubsequence(a: String, b: String): Int {
    val dp = IntArray(b.length + 1) // row i-1, overwritten into row i
    for (i in 1..a.length) {
        var diag = 0 // dp[i-1][j-1]
        for (j in 1..b.length) {
            val up = dp[j] // dp[i-1][j]
            dp[j] = if (a[i - 1] == b[j - 1]) diag + 1 else maxOf(up, dp[j - 1])
            diag = up
        }
    }
    return dp[b.length]
}
