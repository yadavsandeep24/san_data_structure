// Q6. Valid Parentheses (Schema or Deep Link Path)
// Source: book/part-viii/29-interview-questions-q01-q10.md
package ch29.q06_valid_parentheses

fun isValid(s: String): Boolean {
    val st = ArrayDeque<Char>()
    val pair = mapOf(')' to '(', ']' to '[', '}' to '{')
    for (c in s) {
        if (c in "([{") st.addLast(c)
        else if (st.isEmpty() || st.removeLast() != pair[c]) return false
    }
    return st.isEmpty()
}
