// Q12. Justify Text for a Narrow Screen (Agreement Preview)
// Source: book/part-ix/42-document-signing-drill-bank-q08-q13.md
package ch42.q12_justify_text_for_a_narrow_screen

fun justify(words: List<String>, width: Int): List<String> {
    val lines = mutableListOf<String>()
    var i = 0
    while (i < words.size) {
        var j = i
        var len = 0
        while (j < words.size && len + words[j].length + (j - i) <= width) { len += words[j].length; j++ }
        require(j > i) { "word longer than width: ${words[i]}" }
        val gaps = j - i - 1
        val line = if (j == words.size || gaps == 0) {
            words.subList(i, j).joinToString(" ").padEnd(width)   // last line or one word: left-aligned
        } else {
            val spaces = width - len
            val each = spaces / gaps
            val extra = spaces % gaps
            buildString {
                for (k in i until j) {
                    append(words[k])
                    if (k < j - 1) append(" ".repeat(each + if (k - i < extra) 1 else 0))
                }
            }
        }
        lines += line
        i = j
    }
    return lines
}
