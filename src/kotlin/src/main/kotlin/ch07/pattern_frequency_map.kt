// Pattern: frequency map
// Source: book/part-iii/07-hash-tables.md
package ch07.pattern_frequency_map

fun freq(s: String): Map<Char, Int> {
    val m = HashMap<Char, Int>()
    for (c in s) m[c] = (m[c] ?: 0) + 1
    return m
}
