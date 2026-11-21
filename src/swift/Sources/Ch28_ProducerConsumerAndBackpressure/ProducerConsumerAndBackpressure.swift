// Producer-consumer and backpressure (network)
// Source: book/part-vii/28-concurrency.md

actor BoundedBuffer<T> {
    private var q: [T] = []
    private let capacity: Int
    private var putWaiters: [CheckedContinuation<Void, Never>] = []
    private var takeWaiters: [CheckedContinuation<T, Never>] = []

    init(capacity: Int) {
        precondition(capacity > 0)
        self.capacity = capacity
    }

    func put(_ x: T) async {
        while q.count >= capacity {
            await withCheckedContinuation { putWaiters.append($0) }
        }
        if !takeWaiters.isEmpty {
            takeWaiters.removeFirst().resume(returning: x)
        } else {
            q.append(x)
        }
        resumePutWaiters()
    }

    func take() async -> T {
        if !q.isEmpty {
            let x = q.removeFirst()
            resumePutWaiters()
            return x
        }
        return await withCheckedContinuation { takeWaiters.append($0) }
    }

    private func resumePutWaiters() {
        while q.count < capacity, !putWaiters.isEmpty {
            putWaiters.removeFirst().resume()
        }
    }
}
