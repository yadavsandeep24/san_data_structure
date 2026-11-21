// Implementations (four languages)
// Source: book/part-ii/06-queues-deques.md
package ch06.implementations

val q = ArrayDeque<String>()
fun example() {
    q.addLast("a")          // enqueue
    q.addLast("b")
}
val front = q.removeFirst() // "a"
