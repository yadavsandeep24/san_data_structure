// P3: First unique character
// Source: solutions/ch07/README.md
package ch07.p03_first_unique_character

fun firstUniqChar(s: String): Int {
    val freq = IntArray(26)
    for (c in s) freq[c - 'a']++
    for (i in s.indices) if (freq[s[i] - 'a'] == 1) return i
    return -1
}
