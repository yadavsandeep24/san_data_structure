// Q8. Decode Ways (Ambiguous Numeric Codes)
// Source: book/part-viii/36-graphs-dynamic-programming.md
package ch36.q08_decode_ways

fun numDecodings(s: String): Int {
    var prev2 = 1                          // dp[i-2]
    var prev1 = if (s[0] == '0') 0 else 1  // dp[i-1]
    for (i in 2..s.length) {
        var cur = 0
        if (s[i - 1] != '0') cur += prev1
        val two = (s[i - 2] - '0') * 10 + (s[i - 1] - '0')
        if (two in 10..26) cur += prev2
        prev2 = prev1
        prev1 = cur
    }
    return prev1
}
