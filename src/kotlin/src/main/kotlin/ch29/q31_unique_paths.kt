// Q31. Unique Paths
// Source: book/part-viii/29-interview-questions-q31-q40.md
package ch29.q31_unique_paths

fun uniquePaths(m: Int, n: Int): Int {
    val dp = IntArray(n) { 1 }
    for (i in 1 until m) for (j in 1 until n) dp[j] += dp[j - 1]
    return dp[n - 1]
}
