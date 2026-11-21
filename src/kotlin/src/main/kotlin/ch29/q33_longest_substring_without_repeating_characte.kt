// Q33. Longest Substring Without Repeating Characters
// Source: book/part-viii/29-interview-questions-q31-q40.md
package ch29.q33_longest_substring_without_repeating_characte

fun lengthOfLongestSubstring(s: String): Int {
    val last = HashMap<Char, Int>()
    var left = 0; var best = 0
    for (i in s.indices) {
        val c = s[i]
        val prev = last[c]
        if (prev != null && prev >= left) left = prev + 1
        last[c] = i
        best = maxOf(best, i - left + 1)
    }
    return best
}
