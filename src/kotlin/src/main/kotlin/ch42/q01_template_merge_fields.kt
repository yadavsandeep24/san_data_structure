// Q1. Template Merge Fields (Envelope Email Body)
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md
package ch42.q01_template_merge_fields

fun render(
    t: String,
    values: Map<String, String>,
    onMissing: (String) -> String = { "{{$it}}" },
): String {
    val sb = StringBuilder(t.length)
    var i = 0
    while (i < t.length) {
        when {
            t.startsWith("\\{{", i) -> { sb.append("{{"); i += 3 }
            t.startsWith("{{", i) -> {
                val end = t.indexOf("}}", i + 2)
                require(end != -1) { "Unclosed field at index $i" }
                val key = t.substring(i + 2, end).trim()
                sb.append(values[key] ?: onMissing(key))
                i = end + 2
            }
            else -> { sb.append(t[i]); i++ }
        }
    }
    return sb.toString()
}
