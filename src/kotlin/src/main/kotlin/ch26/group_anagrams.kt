// Group anagrams
// Source: book/part-vii/26-strings.md
package ch26.group_anagrams

fun groupAnagrams(strs: Array<String>): List<List<String>> {
    val map = HashMap<String, MutableList<String>>()
    for (s in strs) {
        val key = s.toCharArray().sorted().joinToString("")
        map.getOrPut(key) { mutableListOf() }.add(s)
    }
    return map.values.toList()
}
