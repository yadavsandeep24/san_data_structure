// Q3. Group Anagrams (Facet Grouping)
// Source: book/part-viii/29-interview-questions-q01-q10.md
package ch29.q03_group_anagrams

fun groupAnagrams(strs: Array<String>): List<List<String>> {
    val m = HashMap<String, MutableList<String>>()
    for (s in strs) {
        val k = s.toCharArray().sorted().joinToString("")
        m.getOrPut(k) { mutableListOf() }.add(s)
    }
    return m.values.toList()
}
