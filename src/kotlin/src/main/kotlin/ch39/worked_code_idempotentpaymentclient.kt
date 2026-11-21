// Worked code (b) — IdempotentPaymentClient
// Source: book/part-ix/39-money-idempotency-reliability.md
package ch39.worked_code_idempotentpaymentclient
import kotlinx.coroutines.*
import kotlinx.coroutines.sync.*

class IdempotentPaymentClient(
    private val post: suspend (path: String, headers: Map<String, String>, body: String) -> String,
) {
    private val mutex = kotlinx.coroutines.sync.Mutex()
    private val inFlight = mutableMapOf<String, kotlinx.coroutines.CompletableDeferred<String>>()

    suspend fun createPayment(
        intentId: String,
        amountMinor: Long,
        currencyCode: String,
        idempotencyKey: String,
    ): String {
        val body =
            """{"intentId":"$intentId","amountMinor":$amountMinor,"currency":"$currencyCode"}"""
        val existing = mutex.withLock { inFlight[idempotencyKey] }
        if (existing != null) return existing.await()

        val mine = kotlinx.coroutines.CompletableDeferred<String>()
        val winner = mutex.withLock {
            inFlight.putIfAbsent(idempotencyKey, mine) ?: mine
        }
        if (winner !== mine) return winner.await()

        return try {
            val result = post(
                "/v1/payments",
                mapOf("Idempotency-Key" to idempotencyKey),
                body,
            )
            mine.complete(result)
            result
        } catch (t: Throwable) {
            mine.completeExceptionally(t)
            throw t
        } finally {
            mutex.withLock { inFlight.remove(idempotencyKey) }
        }
    }
}
