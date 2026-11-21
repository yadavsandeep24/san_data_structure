// Q6. Longest Repeating Character Replacement (Fix k Typos in a Streak)
// Source: book/part-viii/32-two-pointers-windows-intervals.md
package ch32.q06_longest_repeating_character_replacement

fun characterReplacement(s: String, k: Int): Int {
    val count = IntArray(26)
    var left = 0
    var maxFreq = 0
    var best = 0
    for (right in s.indices) {
        maxFreq = maxOf(maxFreq, ++count[s[right] - 'A'])
        while (right - left + 1 - maxFreq > k) {
            count[s[left] - 'A']--
            left++
        }
        best = maxOf(best, right - left + 1)
    }
    return best
}
