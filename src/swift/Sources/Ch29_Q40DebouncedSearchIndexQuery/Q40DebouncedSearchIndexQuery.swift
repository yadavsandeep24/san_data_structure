// Q40. Debounced Search Index Query
// Source: book/part-viii/29-interview-questions-q31-q40.md

final class DebouncedSearch {
    private let delayMs: UInt64
    private let search: (String) async -> [String]
    private let publish: ([String]) -> Void
    private var gen = 0
    private var task: Task<Void, Never>?
    init(delayMs: UInt64, search: @escaping (String) async -> [String], publish: @escaping ([String]) -> Void) {
        self.delayMs = delayMs; self.search = search; self.publish = publish
    }
    func onQuery(_ text: String) {
        gen += 1
        let my = gen
        task?.cancel()
        task = Task {
            try? await Task.sleep(nanoseconds: delayMs * 1_000_000)
            guard my == gen, !Task.isCancelled else { return }
            let result = await search(text)
            guard my == gen else { return }
            publish(result)
        }
    }
}
