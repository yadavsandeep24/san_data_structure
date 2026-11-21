// P2: Min stack
// Source: solutions/ch05/README.md
package ch05.p02_min_stack

class MinStack {
    private val vals = ArrayDeque<Int>()
    private val mins = ArrayDeque<Int>()

    fun push(x: Int) {
        vals.addLast(x)
        mins.addLast(if (mins.isEmpty()) x else minOf(x, mins.last()))
    }

    fun pop() {
        vals.removeLast()
        mins.removeLast()
    }

    fun top(): Int = vals.last()
    fun getMin(): Int = mins.last()
}
