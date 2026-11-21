// P6. Thread-Safe Request Coalescer
// Source: solutions/ch38/README.md

actor Coalescer<T> {
    private var inflight: [String: Task<T, Error>] = [:]
    func load(_ key: String, produce: @escaping () async throws -> T) async throws -> T {
        if let t = inflight[key] { return try await t.value }
        let task = Task { try await produce() }
        inflight[key] = task
        defer { inflight[key] = nil }
        return try await task.value
    }
}
