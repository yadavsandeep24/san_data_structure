// P3: Offline intent queue flush without double-charge
// Source: solutions/ch39/README.md

enum PaymentFailure: Error {
    case permanent(String)
    case transient(String)
}

protocol PendingListStore: Sendable {
    func loadAll() async -> [String]
    func saveAll(_ ids: [String]) async
}

final class OfflinePaymentQueue {
    private let store: any IntentStore
    private let listStore: any PendingListStore // loadAll / saveAll of intentIds
    private let client: IdempotentPaymentClient
    private let statusGet: (String) async -> String? // nil if unsupported

    init(
        store: any IntentStore,
        listStore: any PendingListStore,
        client: IdempotentPaymentClient,
        statusGet: @escaping (String) async -> String?
    ) {
        self.store = store
        self.listStore = listStore
        self.client = client
        self.statusGet = statusGet
    }

    func enqueue(_ intent: PaymentIntent) async {
        await store.save(intent)
        var ids = await listStore.loadAll()
        if !ids.contains(intent.intentId) {
            ids.append(intent.intentId)
            await listStore.saveAll(ids)
        }
    }

    func flush() async {
        for id in await listStore.loadAll() {
            guard var intent = await store.load(id), intent.status == "pending" else { continue }

            if let remote = await statusGet(id), remote == "succeeded" || remote == "failed" {
                intent.status = remote
                await store.save(intent)
                continue
            }

            do {
                _ = try await client.createPayment(id)
            } catch PaymentFailure.permanent {
                intent.status = "failed"
                await store.save(intent)
            } catch {
                // transient / unknown — leave pending; same key next flush
            }
        }
    }
}
