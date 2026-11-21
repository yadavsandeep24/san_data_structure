// P2: Top K frequent
// Source: solutions/ch12/README.md
package ch12.p02_top_k_frequent

fun topKFrequent(nums: IntArray, k: Int): IntArray {
    val freq = HashMap<Int, Int>()
    for (x in nums) freq[x] = (freq[x] ?: 0) + 1
    val pq = java.util.PriorityQueue<IntArray> { a, b -> a[0] - b[0] } // [freq, value]
    for ((v, f) in freq) {
        pq.offer(intArrayOf(f, v))
        if (pq.size > k) pq.poll()
    }
    return IntArray(pq.size) { pq.poll()[1] }
}
