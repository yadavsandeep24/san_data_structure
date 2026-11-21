// Language realities
// Source: book/part-iii/12-heaps-priority-queues.md
package ch12.language_realities

val minPq = java.util.PriorityQueue<Int>()
fun example() {
    minPq += 5; minPq += 1; minPq += 3
    minPq.poll() // 1
}

val maxPq = java.util.PriorityQueue<Int>(compareByDescending { it })
