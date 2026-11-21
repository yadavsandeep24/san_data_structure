// Worked code (b) — IdempotentPaymentClient
// Source: book/part-ix/39-money-idempotency-reliability.md

actor IdempotentPaymentClient {
    private var inFlight: [String: Task<String, Error>] = [:]
    private let post: (String, [String: String], String) async throws -> String

    init(post: @escaping (String, [String: String], String) async throws -> String) {
        self.post = post
    }

    func createPayment(
        intentId: String,
        amountMinor: Int64,
        currencyCode: String,
        idempotencyKey: String
    ) async throws -> String {
        if let existing = inFlight[idempotencyKey] {
            return try await existing.value
        }
        let task = Task<String, Error> {
            defer { Task { await self.clear(idempotencyKey) } }
            let body =
                "{\"intentId\":\"\(intentId)\",\"amountMinor\":\(amountMinor),\"currency\":\"\(currencyCode)\"}"
            return try await post("/v1/payments", ["Idempotency-Key": idempotencyKey], body)
        }
        inFlight[idempotencyKey] = task
        return try await task.value
    }

    private func clear(_ key: String) {
        inFlight[key] = nil
    }
}
