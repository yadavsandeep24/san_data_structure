// Classic patterns
// Source: book/part-ii/06-queues-deques.md
package ch06.classic_patterns

class MyQueue {
    private val `in` = ArrayDeque<Int>()
    private val out = ArrayDeque<Int>()

    fun push(x: Int) = `in`.addLast(x)

    fun pop(): Int {
        move()
        return out.removeLast()
    }

    fun peek(): Int {
        move()
        return out.last()
    }

    fun empty() = `in`.isEmpty() && out.isEmpty()

    private fun move() {
        if (out.isEmpty()) while (`in`.isNotEmpty()) out.addLast(`in`.removeLast())
    }
}

fun maxSlidingWindow(nums: IntArray, k: Int): IntArray {
    if (nums.isEmpty() || k == 0) return intArrayOf()
    val dq = ArrayDeque<Int>() // indices
    val res = IntArray(nums.size - k + 1)
    for (i in nums.indices) {
        while (dq.isNotEmpty() && dq.first() <= i - k) dq.removeFirst()
        while (dq.isNotEmpty() && nums[dq.last()] <= nums[i]) dq.removeLast()
        dq.addLast(i)
        if (i >= k - 1) res[i - k + 1] = nums[dq.first()]
    }
    return res
}
