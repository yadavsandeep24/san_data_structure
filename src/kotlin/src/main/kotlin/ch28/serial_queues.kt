// Serial queues
// Source: book/part-vii/28-concurrency.md
package ch28.serial_queues
import kotlinx.coroutines.sync.*

class Counter {
    private val mutex = kotlinx.coroutines.sync.Mutex()
    private var value = 0
    suspend fun increment() = mutex.withLock { value++ }
    suspend fun get() = mutex.withLock { value }
}
