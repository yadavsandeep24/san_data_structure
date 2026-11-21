// P2: Longest palindromic substring
// Source: solutions/ch26/README.md
package ch26.p02_longest_palindromic_substring

fun longestPalindrome(s: String): String {
    if (s.isEmpty()) return ""
    var start = 0
    var end = 0
    fun expand(l: Int, r: Int): Pair<Int, Int> {
        var left = l
        var right = r
        while (left >= 0 && right < s.length && s[left] == s[right]) {
            left--
            right++
        }
        return (left + 1) to (right - 1)
    }
    for (i in s.indices) {
        val (a, b) = expand(i, i)
        val (c, d) = expand(i, i + 1)
        if (b - a > end - start) {
            start = a
            end = b
        }
        if (d - c > end - start) {
            start = c
            end = d
        }
    }
    return s.substring(start, end + 1)
}
