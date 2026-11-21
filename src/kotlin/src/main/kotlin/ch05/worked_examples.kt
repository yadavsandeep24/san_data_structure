// Worked examples (four languages)
// Source: book/part-ii/05-stacks.md
package ch05.worked_examples

class Stack<T> {
    private val data = ArrayDeque<T>()
    fun push(x: T) = data.addLast(x)
    fun pop(): T = data.removeLast()
    fun peek(): T = data.last()
    fun isEmpty() = data.isEmpty()
}

fun isValid(s: String): Boolean {
    val st = ArrayDeque<Char>()
    val pair = mapOf(')' to '(', ']' to '[', '}' to '{')
    for (c in s) {
        if (c in "([{") st.addLast(c)
        else if (st.isEmpty() || st.removeLast() != pair[c]) return false
    }
    return st.isEmpty()
}

class MinStack {
    private val vals = ArrayDeque<Int>()
    private val mins = ArrayDeque<Int>()

    fun push(x: Int) {
        vals.addLast(x)
        mins.addLast(if (mins.isEmpty()) x else minOf(x, mins.last()))
    }
    fun pop() { vals.removeLast(); mins.removeLast() }
    fun top() = vals.last()
    fun getMin() = mins.last()
}
