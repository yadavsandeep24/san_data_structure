// Atomics
// Source: book/part-vii/28-concurrency.md
package ch28.atomics

val count = java.util.concurrent.atomic.AtomicInteger(0)
fun example() {
    count.incrementAndGet()
}
