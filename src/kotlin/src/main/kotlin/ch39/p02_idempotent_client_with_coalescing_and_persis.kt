// P2: Idempotent client with coalescing and persisted key
// Source: solutions/ch39/README.md
package ch39.p02_idempotent_client_with_coalescing_and_persis
import kotlinx.coroutines.*
import kotlinx.coroutines.sync.*

data class PaymentIntent(
    val intentId: String,
    val amountMinor: Long,
    val currencyCode: String,
    val idempotencyKey: String,
    var status: String = "pending", // pending | succeeded | failed
)

interface IntentStore {
    suspend fun load(intentId: String): PaymentIntent?
    suspend fun save(intent: PaymentIntent)
}

class IdempotentPaymentClient(
    private val store: IntentStore,
    private val post: suspend (headers: Map<String, String>, body: String) -> String,
) {
    private val mutex = kotlinx.coroutines.sync.Mutex()
    private val inFlight = mutableMapOf<String, kotlinx.coroutines.CompletableDeferred<String>>()

    /** Call once when user confirms Pay. */
    suspend fun beginIntent(intentId: String, amountMinor: Long, currencyCode: String): PaymentIntent {
        store.load(intentId)?.let { return it }
        val intent = PaymentIntent(
            intentId = intentId,
            amountMinor = amountMinor,
            currencyCode = currencyCode,
            idempotencyKey = java.util.UUID.randomUUID().toString(),
        )
        store.save(intent)
        return intent
    }

    suspend fun createPayment(intentId: String): String {
        val intent = store.load(intentId) ?: error("missing intent")
        val body =
            """{"intentId":"$intentId","amountMinor":${intent.amountMinor},"currency":"${intent.currencyCode}"}"""
        val key = intent.idempotencyKey

        val existing = mutex.withLock { inFlight[key] }
        if (existing != null) return existing.await()

        val mine = kotlinx.coroutines.CompletableDeferred<String>()
        val winner = mutex.withLock { inFlight.putIfAbsent(key, mine) ?: mine }
        if (winner !== mine) return winner.await()

        return try {
            val result = post(mapOf("Idempotency-Key" to key), body)
            intent.status = "succeeded"
            store.save(intent)
            mine.complete(result)
            result
        } catch (t: Throwable) {
            mine.completeExceptionally(t)
            throw t
        } finally {
            mutex.withLock { inFlight.remove(key) }
        }
    }
}
