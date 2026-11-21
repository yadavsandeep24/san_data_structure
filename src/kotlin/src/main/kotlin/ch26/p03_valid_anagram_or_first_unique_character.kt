// P3: Valid anagram or first unique character
// Source: solutions/ch26/README.md
package ch26.p03_valid_anagram_or_first_unique_character

fun isAnagram(s: String, t: String): Boolean {
    if (s.length != t.length) return false
    val cnt = IntArray(26)
    for (i in s.indices) {
        cnt[s[i] - 'a']++
        cnt[t[i] - 'a']--
    }
    return cnt.all { it == 0 }
}

fun firstUniqChar(s: String): Int {
    val cnt = IntArray(26)
    for (c in s) cnt[c - 'a']++
    for (i in s.indices) if (cnt[s[i] - 'a'] == 1) return i
    return -1
}
