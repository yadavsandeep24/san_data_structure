// Q10. Find All Anagrams in a String (Every Scrambled Match)
// Source: book/part-viii/32-two-pointers-windows-intervals.md
package ch32.q10_find_all_anagrams_in_a_string

fun findAnagrams(s: String, p: String): List<Int> {
    val out = mutableListOf<Int>()
    if (p.length > s.length) return out
    val need = IntArray(26)
    for (c in p) need[c - 'a']++
    var missing = p.length
    for (i in s.indices) {
        if (need[s[i] - 'a']-- > 0) missing--
        if (i >= p.length && ++need[s[i - p.length] - 'a'] > 0) missing++
        if (missing == 0) out.add(i - p.length + 1)
    }
    return out
}
