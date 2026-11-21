// P3: Bounded request queue with drop policy
// Source: solutions/ch06/README.md
package ch06.p03_bounded_request_queue_with_drop_policy

enum class DropPolicy { DropNewest, DropOldest }

class BoundedRequestQueue(
    private val capacity: Int,
    private val maxInFlight: Int,
    private val policy: DropPolicy,
    private val execute: (Request) -> Unit,
) {
    data class Request(val id: String, val payload: ByteArray)

    private val pending = ArrayDeque<Request>()
    private var inFlight = 0

    @Synchronized
    fun submit(req: Request): Boolean {
        if (pending.size + inFlight >= capacity) {
            when (policy) {
                DropPolicy.DropNewest -> return false
                DropPolicy.DropOldest -> if (pending.isNotEmpty()) pending.removeFirst() else return false
            }
        }
        pending.addLast(req)
        pump()
        return true
    }

    @Synchronized
    fun onComplete() {
        inFlight = (inFlight - 1).coerceAtLeast(0)
        pump()
    }

    private fun pump() {
        while (inFlight < maxInFlight && pending.isNotEmpty()) {
            val next = pending.removeFirst()
            inFlight++
            execute(next)
        }
    }
}
