// P3: Last stone weight
// Source: solutions/ch12/README.md
package ch12.p03_last_stone_weight

fun lastStoneWeight(stones: IntArray): Int {
    val pq = java.util.PriorityQueue<Int>(compareByDescending { it })
    for (s in stones) pq.offer(s)
    while (pq.size > 1) {
        val x = pq.poll()
        val y = pq.poll()
        if (x != y) pq.offer(x - y)
    }
    return if (pq.isEmpty()) 0 else pq.peek()
}
