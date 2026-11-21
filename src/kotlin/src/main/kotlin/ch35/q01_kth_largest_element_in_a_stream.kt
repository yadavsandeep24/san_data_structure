// Q1. Kth Largest Element in a Stream (Live Leaderboard Cutoff)
// Source: book/part-viii/35-heaps-tries-greedy.md
package ch35.q01_kth_largest_element_in_a_stream

import java.util.PriorityQueue

class KthLargest(private val k: Int, nums: IntArray) {
    private val heap = PriorityQueue<Int>() // min-heap holding the top k

    init {
        nums.forEach { add(it) }
    }

    fun add(v: Int): Int {
        heap.offer(v)
        if (heap.size > k) heap.poll()
        return heap.peek()
    }
}
