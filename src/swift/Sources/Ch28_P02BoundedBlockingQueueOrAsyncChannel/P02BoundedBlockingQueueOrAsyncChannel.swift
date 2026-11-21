// P2: Bounded blocking queue or async channel
// Source: solutions/ch28/README.md

actor BoundedAsyncQueue<T> {
    private var storage: [T] = []
    private let capacity: Int
    private var putWaiters: [CheckedContinuation<Void, Never>] = []
    private var takeWaiters: [CheckedContinuation<T, Never>] = []

    init(capacity: Int) {
        precondition(capacity > 0)
        self.capacity = capacity
    }

    func put(_ value: T) async {
        while storage.count >= capacity {
            await withCheckedContinuation { putWaiters.append($0) }
        }
        if !takeWaiters.isEmpty {
            let waiter = takeWaiters.removeFirst()
            waiter.resume(returning: value)
        } else {
            storage.append(value)
            if !putWaiters.isEmpty {
                // space unchanged for put waiters unless we drained — n/a
            }
        }
        resumePutWaitersIfNeeded()
    }

    func take() async -> T {
        if !storage.isEmpty {
            let v = storage.removeFirst()
            resumePutWaitersIfNeeded()
            return v
        }
        return await withCheckedContinuation { takeWaiters.append($0) }
    }

    private func resumePutWaitersIfNeeded() {
        while storage.count < capacity, !putWaiters.isEmpty {
            putWaiters.removeFirst().resume()
        }
    }
}
