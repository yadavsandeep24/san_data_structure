// Q6. Halve the Largest k Times (Compress the Biggest Attachments)
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md
package ch42.q06_halve_the_largest_k_times

import java.util.PriorityQueue

fun minSumAfterHalving(nums: IntArray, k: Int): Long {
    val heap = PriorityQueue<Int>(compareByDescending { it })
    nums.forEach { heap.add(it) }
    var sum = nums.sumOf { it.toLong() }
    repeat(k) {
        val top = heap.poll() ?: return sum
        val half = top - top / 2          // ceil(top / 2) without overflowing at Int.MAX_VALUE
        sum -= top - half
        heap.add(half)
    }
    return sum
}
