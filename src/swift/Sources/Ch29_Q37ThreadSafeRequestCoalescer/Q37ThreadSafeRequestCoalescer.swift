// Q37. Thread-Safe Request Coalescer (Single-Flight)
// Source: book/part-viii/29-interview-questions-q31-q40.md

// actor = serialized access to the map (Swift's "thread-safe")
actor Coalescer<T: Sendable> {
    private var inflight: [String: Task<T, Error>] = [:]
    func load(_ key: String, _ produce: @escaping @Sendable () async throws -> T) async throws -> T {
        if let existing = inflight[key] { return try await existing.value }
        let task = Task { try await produce() }
        inflight[key] = task
        defer { inflight[key] = nil }
        return try await task.value
    }
}
