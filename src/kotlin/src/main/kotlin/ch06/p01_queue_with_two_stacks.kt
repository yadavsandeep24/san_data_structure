// P1: Queue with two stacks
// Source: solutions/ch06/README.md
package ch06.p01_queue_with_two_stacks

class MyQueue {
    private val inbound = ArrayDeque<Int>()
    private val outbound = ArrayDeque<Int>()

    fun push(x: Int) = inbound.addLast(x)

    fun pop(): Int {
        move()
        return outbound.removeLast()
    }

    fun peek(): Int {
        move()
        return outbound.last()
    }

    fun empty(): Boolean = inbound.isEmpty() && outbound.isEmpty()

    private fun move() {
        if (outbound.isEmpty()) {
            while (inbound.isNotEmpty()) outbound.addLast(inbound.removeLast())
        }
    }
}
