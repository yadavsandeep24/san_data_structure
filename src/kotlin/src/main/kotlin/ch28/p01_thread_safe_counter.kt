// P1: Thread-safe counter
// Source: solutions/ch28/README.md
package ch28.p01_thread_safe_counter
import kotlinx.coroutines.sync.*

import java.util.concurrent.atomic.AtomicInteger
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock

class AtomicCounter {
    private val value = AtomicInteger(0)
    fun increment(): Int = value.incrementAndGet()
    fun get(): Int = value.get()
}

class MutexCounter {
    private val mutex = Mutex()
    private var value = 0
    suspend fun increment(): Int = mutex.withLock { ++value }
    suspend fun get(): Int = mutex.withLock { value }
}
