// Q7. Min Stack (Debug Overlay)
// Source: book/part-viii/29-interview-questions-q01-q10.md
package ch29.q07_min_stack

class MinStack {
    private val st = ArrayDeque<IntArray>() // [val, min]
    fun push(x: Int) {
        val m = if (st.isEmpty()) x else minOf(x, st.last()[1])
        st.addLast(intArrayOf(x, m))
    }
    fun pop() { st.removeLast() }
    fun top() = st.last()[0]
    fun getMin() = st.last()[1]
}
