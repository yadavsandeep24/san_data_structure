// Sample: k largest values via size-k min-heap (Chapter 18) — not “top-k frequent”
import java.util.PriorityQueue

fun kLargest(nums: IntArray, k: Int): List<Int> {
    val heap = PriorityQueue<Int>() // min-heap of size k
    for (n in nums) {
        heap.offer(n)
        if (heap.size > k) heap.poll()
    }
    return heap.sortedDescending()
}
