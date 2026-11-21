// P2: Group by key or frequency
// Source: solutions/ch07/README.md
package ch07.p02_group_by_key_or_frequency

fun groupAnagrams(strs: Array<String>): List<List<String>> {
    val map = HashMap<String, MutableList<String>>()
    for (s in strs) {
        val key = s.toCharArray().sorted().joinToString("")
        map.getOrPut(key) { mutableListOf() }.add(s)
    }
    return map.values.toList()
}

fun frequencyMap(items: List<String>): Map<String, Int> {
    val m = HashMap<String, Int>()
    for (x in items) m[x] = (m[x] ?: 0) + 1
    return m
}
