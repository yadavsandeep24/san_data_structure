// StringBuilder and concatenation cost
// Source: book/part-vii/26-strings.md
package ch26.stringbuilder_and_concatenation_cost

fun joinCsv(parts: List<String>): String = buildString {
    parts.forEachIndexed { i, p ->
        if (i > 0) append(',')
        append(p)
    }
}
