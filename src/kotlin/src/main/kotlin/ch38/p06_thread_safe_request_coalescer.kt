// P6. Thread-Safe Request Coalescer
// Source: solutions/ch38/README.md
package ch38.p06_thread_safe_request_coalescer
import kotlinx.coroutines.*
import kotlinx.coroutines.sync.*

class Coalescer<T> {
    private val mutex = kotlinx.coroutines.sync.Mutex()
    private val inflight = HashMap<String, kotlinx.coroutines.Deferred<T>>()

    suspend fun load(key: String, produce: suspend () -> T): T = coroutineScope {
        val deferred = mutex.withLock {
            inflight.getOrPut(key) { async { produce() } }
        }
        try {
            deferred.await()
        } finally {
            mutex.withLock { inflight.remove(key) }
        }
    }
}
