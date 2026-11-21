// Q32. First Unique Character
// Source: book/part-viii/29-interview-questions-q31-q40.md
package ch29.q32_first_unique_character

fun firstUniqChar(s: String): Int {
    val freq = HashMap<Char, Int>()
    for (c in s) freq[c] = (freq[c] ?: 0) + 1
    for (i in s.indices) if (freq[s[i]] == 1) return i
    return -1
}
