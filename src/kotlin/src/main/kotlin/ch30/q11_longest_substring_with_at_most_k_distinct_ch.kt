// Q11. Longest Substring with At Most K Distinct Characters
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md
package ch30.q11_longest_substring_with_at_most_k_distinct_ch

fun lengthOfLongestSubstringKDistinct(s: String, k: Int): Int {
    if (k == 0) return 0
    val freq = HashMap<Char, Int>()
    var lo = 0
    var best = 0
    for (hi in s.indices) {
        freq[s[hi]] = (freq[s[hi]] ?: 0) + 1
        while (freq.size > k) {
            val c = s[lo++]
            freq[c] = freq[c]!! - 1
            if (freq[c] == 0) freq.remove(c)
        }
        best = maxOf(best, hi - lo + 1)
    }
    return best
}
