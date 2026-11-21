// P2: Bounded blocking queue or async channel
// Source: solutions/ch28/README.md
package ch28.p02_bounded_blocking_queue_or_async_channel
import kotlinx.coroutines.*
import kotlinx.coroutines.channels.*
import kotlinx.coroutines.sync.*

import java.util.concurrent.locks.ReentrantLock
import kotlin.concurrent.withLock
import kotlinx.coroutines.channels.Channel

/** Classic blocking bounded queue. */
class BoundedBlockingQueue<T>(private val capacity: Int) {
    private val q = ArrayDeque<T>()
    private val lock = ReentrantLock()
    private val notEmpty = lock.newCondition()
    private val notFull = lock.newCondition()

    fun put(item: T) {
        lock.withLock {
            while (q.size == capacity) notFull.await()
            q.addLast(item)
            notEmpty.signal()
        }
    }

    fun take(): T = lock.withLock {
        while (q.isEmpty()) notEmpty.await()
        val item = q.removeFirst()
        notFull.signal()
        item
    }
}

/** Async channel sketch (preferred in coroutines). */
fun <T> boundedChannel(capacity: Int) = Channel<T>(capacity)
// producer: channel.send(x)  // suspends when full
// consumer: channel.receive() / for (x in channel)
