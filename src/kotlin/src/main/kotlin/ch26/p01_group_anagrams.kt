// P1: Group anagrams
// Source: solutions/ch26/README.md
package ch26.p01_group_anagrams

fun groupAnagrams(strs: Array<String>): List<List<String>> {
    val map = HashMap<String, MutableList<String>>()
    for (s in strs) {
        val key = s.toCharArray().sorted().joinToString("")
        map.getOrPut(key) { mutableListOf() }.add(s)
    }
    return map.values.toList()
}

// Alternative frequency key for a–z:
fun groupAnagramsCounts(strs: Array<String>): List<List<String>> {
    val map = HashMap<String, MutableList<String>>()
    for (s in strs) {
        val cnt = IntArray(26)
        for (c in s) cnt[c - 'a']++
        val key = cnt.joinToString("#")
        map.getOrPut(key) { mutableListOf() }.add(s)
    }
    return map.values.toList()
}
