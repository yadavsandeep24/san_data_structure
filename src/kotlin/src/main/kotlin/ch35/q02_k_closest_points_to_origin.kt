// Q2. K Closest Points to Origin (Nearest Stores on the Map)
// Source: book/part-viii/35-heaps-tries-greedy.md
package ch35.q02_k_closest_points_to_origin

import java.util.PriorityQueue

fun kClosest(points: Array<IntArray>, k: Int): Array<IntArray> {
    fun dist(p: IntArray): Long = p[0].toLong() * p[0] + p[1].toLong() * p[1]
    val maxHeap = PriorityQueue<IntArray>(compareByDescending { dist(it) })
    for (p in points) {
        maxHeap.offer(p)
        if (maxHeap.size > k) maxHeap.poll() // drop the farthest
    }
    return maxHeap.toTypedArray()
}
