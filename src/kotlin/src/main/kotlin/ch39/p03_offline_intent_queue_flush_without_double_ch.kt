// P3: Offline intent queue flush without double-charge
// Source: solutions/ch39/README.md
package ch39.p03_offline_intent_queue_flush_without_double_ch

import ch39.p02_idempotent_client_with_coalescing_and_persis.IdempotentPaymentClient
import ch39.p02_idempotent_client_with_coalescing_and_persis.IntentStore
import ch39.p02_idempotent_client_with_coalescing_and_persis.PaymentIntent

class OfflinePaymentQueue(
    private val store: IntentStore,
    private val listStore: PendingListStore, // loadAll / saveAll of intentIds
    private val client: IdempotentPaymentClient,
    private val statusGet: suspend (intentId: String) -> String?, // nullable if unsupported
) {
    suspend fun enqueue(intent: PaymentIntent) {
        store.save(intent)
        val ids = listStore.loadAll().toMutableList()
        if (intent.intentId !in ids) {
            ids += intent.intentId
            listStore.saveAll(ids)
        }
    }

    suspend fun flush() {
        val ids = listStore.loadAll()
        for (id in ids) {
            val intent = store.load(id) ?: continue
            if (intent.status != "pending") continue

            when (statusGet(id)) {          // null = status endpoint unsupported → just retry
                "succeeded" -> {
                    intent.status = "succeeded"
                    store.save(intent)
                    continue
                }
                "failed" -> {
                    intent.status = "failed"
                    store.save(intent)
                    continue
                }
            }

            try {
                client.createPayment(id)
            } catch (e: PermanentPaymentException) {
                intent.status = "failed"
                store.save(intent)
            } catch (_: TransientPaymentException) {
                // leave pending — same key next flush
            }
        }
    }
}

class PermanentPaymentException(message: String) : Exception(message)
class TransientPaymentException(message: String) : Exception(message)

interface PendingListStore {
    suspend fun loadAll(): List<String>
    suspend fun saveAll(ids: List<String>)
}
