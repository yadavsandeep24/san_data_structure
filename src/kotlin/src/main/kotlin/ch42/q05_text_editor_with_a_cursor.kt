// Q5. Text Editor with a Cursor (Note Field on a Form)
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md
package ch42.q05_text_editor_with_a_cursor

class TextEditor {
    private val left = StringBuilder()
    private val right = StringBuilder()   // stored backwards: its end is the cursor

    fun insert(text: String) {
        left.append(text)
    }

    fun left(x: Int) {
        repeat(minOf(x, left.length)) {
            right.append(left[left.length - 1]); left.setLength(left.length - 1)
        }
    }

    fun right(x: Int) {
        repeat(minOf(x, right.length)) {
            left.append(right[right.length - 1]); right.setLength(right.length - 1)
        }
    }

    fun backspace(x: Int): Int {
        val n = minOf(x, left.length)
        left.setLength(left.length - n)
        return n
    }

    fun delete(x: Int): Int {
        val n = minOf(x, right.length)
        right.setLength(right.length - n)
        return n
    }

    // Up to x characters immediately left of the cursor.
    fun print(x: Int): String = left.substring(maxOf(0, left.length - x))

    fun text(): String = left.toString() + right.reversed().toString()
}
