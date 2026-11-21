// Q25. Kth Largest Element
// Source: book/part-viii/29-interview-questions-q21-q30.md
package ch29.q25_kth_largest_element

fun findKthLargest(nums: IntArray, k: Int): Int {
    val pq = java.util.PriorityQueue<Int>()
    for (x in nums) {
        pq.add(x)
        if (pq.size > k) pq.poll()
    }
    return pq.peek()
}
