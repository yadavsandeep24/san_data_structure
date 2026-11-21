// Q8. Sliding Window Maximum (Scroll Velocity)
// Source: book/part-viii/29-interview-questions-q01-q10.md
package ch29.q08_sliding_window_maximum

fun maxSlidingWindow(nums: IntArray, k: Int): IntArray {
    val dq = ArrayDeque<Int>()
    val out = IntArray(nums.size - k + 1)
    for (i in nums.indices) {
        while (dq.isNotEmpty() && dq.first() <= i - k) dq.removeFirst()
        while (dq.isNotEmpty() && nums[dq.last()] <= nums[i]) dq.removeLast()
        dq.addLast(i)
        if (i >= k - 1) out[i - k + 1] = nums[dq.first()]
    }
    return out
}
