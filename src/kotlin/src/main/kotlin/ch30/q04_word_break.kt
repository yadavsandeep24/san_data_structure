// Q4. Word Break
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md
package ch30.q04_word_break

fun wordBreak(s: String, wordDict: List<String>): Boolean {
    val dict = wordDict.toHashSet()
    val n = s.length
    val dp = BooleanArray(n + 1).also { it[0] = true }
    val maxLen = dict.maxOfOrNull { it.length } ?: 0
    for (i in 0 until n) {
        if (!dp[i]) continue
        for (len in 1..minOf(maxLen, n - i)) {
            if (s.substring(i, i + len) in dict) dp[i + len] = true
        }
    }
    return dp[n]
}
