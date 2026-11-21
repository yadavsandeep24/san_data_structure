// Q37. Thread-Safe Request Coalescer (Single-Flight)
// Source: book/part-viii/29-interview-questions-q31-q40.md
package ch29.q37_thread_safe_request_coalescer
import kotlinx.coroutines.*
import kotlinx.coroutines.sync.*

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Deferred
import kotlinx.coroutines.async
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock

// scope needs a SupervisorJob, or one failed fetch cancels every later load
class Coalescer<T>(private val scope: CoroutineScope) {
    private val mutex = Mutex()
    private val inflight = HashMap<String, Deferred<T>>()
    suspend fun load(key: String, produce: suspend () -> T): T {
        val shared = mutex.withLock {
            inflight.getOrPut(key) {
                scope.async {
                    try { produce() } finally { mutex.withLock { inflight.remove(key) } }
                }
            }
        }
        return shared.await()
    }
}
