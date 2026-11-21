// Q7. Permutation in String (Scrambled Code Search)
// Source: book/part-viii/32-two-pointers-windows-intervals.md
package ch32.q07_permutation_in_string

fun checkInclusion(s1: String, s2: String): Boolean {
    if (s1.length > s2.length) return false
    val need = IntArray(26)
    for (c in s1) need[c - 'a']++
    var missing = s1.length
    for (i in s2.indices) {
        if (need[s2[i] - 'a']-- > 0) missing--
        if (i >= s1.length && ++need[s2[i - s1.length] - 'a'] > 0) missing++
        if (missing == 0) return true
    }
    return false
}
