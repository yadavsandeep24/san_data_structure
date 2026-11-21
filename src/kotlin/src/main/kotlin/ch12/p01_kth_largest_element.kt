// P1: Kth largest element
// Source: solutions/ch12/README.md
package ch12.p01_kth_largest_element

fun findKthLargest(nums: IntArray, k: Int): Int {
    val pq = java.util.PriorityQueue<Int>() // min-heap
    for (x in nums) {
        pq.offer(x)
        if (pq.size > k) pq.poll()
    }
    return pq.peek()
}
