// P1: Valid parentheses
// Source: solutions/ch05/README.md
package ch05.p01_valid_parentheses

fun isValid(s: String): Boolean {
    val st = ArrayDeque<Char>()
    val pair = mapOf(')' to '(', ']' to '[', '}' to '{')
    for (c in s) {
        when (c) {
            '(', '[', '{' -> st.addLast(c)
            else -> if (st.isEmpty() || st.removeLast() != pair[c]) return false
        }
    }
    return st.isEmpty()
}
