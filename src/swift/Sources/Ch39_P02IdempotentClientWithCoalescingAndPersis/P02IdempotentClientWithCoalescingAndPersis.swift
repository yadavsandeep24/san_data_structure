// P2: Idempotent client with coalescing and persisted key
// Source: solutions/ch39/README.md
import Foundation

struct PaymentIntent: Codable, Equatable {
    let intentId: String
    let amountMinor: Int64
    let currencyCode: String
    let idempotencyKey: String
    var status: String = "pending" // pending | succeeded | failed
}

protocol IntentStore: Sendable {
    func load(_ intentId: String) async -> PaymentIntent?
    func save(_ intent: PaymentIntent) async
}

struct MissingIntent: Error {}

actor IdempotentPaymentClient {
    typealias Poster = @Sendable (_ headers: [String: String], _ body: String) async throws -> String
    private let store: any IntentStore
    private let post: Poster
    private var inFlight: [String: Task<String, Error>] = [:]

    init(store: any IntentStore, post: @escaping Poster) {
        self.store = store
        self.post = post
    }

    /// Call once when user confirms Pay.
    func beginIntent(_ intentId: String, amountMinor: Int64, currencyCode: String) async -> PaymentIntent {
        if let existing = await store.load(intentId) { return existing }
        let intent = PaymentIntent(
            intentId: intentId,
            amountMinor: amountMinor,
            currencyCode: currencyCode,
            idempotencyKey: UUID().uuidString
        )
        await store.save(intent)
        return intent
    }

    func createPayment(_ intentId: String) async throws -> String {
        guard var intent = await store.load(intentId) else { throw MissingIntent() }
        let key = intent.idempotencyKey
        // No `await` between this check and the insert below, so the actor cannot interleave.
        if let existing = inFlight[key] { return try await existing.value }

        let body =
            "{\"intentId\":\"\(intentId)\",\"amountMinor\":\(intent.amountMinor),\"currency\":\"\(intent.currencyCode)\"}"
        let post = self.post
        let task = Task<String, Error> { try await post(["Idempotency-Key": key], body) }
        inFlight[key] = task
        defer { inFlight[key] = nil }

        let result = try await task.value
        intent.status = "succeeded"
        await store.save(intent)
        return result
    }
}
