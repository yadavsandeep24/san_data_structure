// Kotlin, Dart and TypeScript string notes
// Source: book/part-vii/26-strings.md
package ch26.kotlin_dart_and_typescript_string_notes

fun graphemeCount(s: String): Int {
    val it = java.text.BreakIterator.getCharacterInstance()
    it.setText(s)
    var n = 0
    while (it.next() != java.text.BreakIterator.DONE) n++
    return n
}

val flag = "🇺🇸"
val units = flag.length                              // 4 (UTF-16 code units)
val codePoints = flag.codePointCount(0, flag.length) // 2 (code points)
val graphemes = graphemeCount(flag)                  // 1 (JDK 20+; Android: android.icu.text.BreakIterator)
