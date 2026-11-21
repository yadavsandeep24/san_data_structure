// P3: Bounded request queue with drop policy
// Source: solutions/ch06/README.md
import Foundation

enum DropPolicy { case dropNewest, dropOldest }

final class BoundedRequestQueue {
    struct Request { let id: String; let payload: Data }

    private let capacity: Int
    private let maxInFlight: Int
    private let policy: DropPolicy
    private let execute: (Request) -> Void
    private var pending = Queue<Request>()
    private var inFlight = 0
    private let lock = NSLock()

    init(capacity: Int, maxInFlight: Int, policy: DropPolicy, execute: @escaping (Request) -> Void) {
        self.capacity = capacity
        self.maxInFlight = maxInFlight
        self.policy = policy
        self.execute = execute
    }

    @discardableResult
    func submit(_ req: Request) -> Bool {
        lock.lock(); defer { lock.unlock() }
        if pendingCount() + inFlight >= capacity {
            switch policy {
            case .dropNewest: return false
            case .dropOldest:
                guard pending.dequeue() != nil else { return false }
            }
        }
        pending.enqueue(req)
        pump()
        return true
    }

    func onComplete() {
        lock.lock(); defer { lock.unlock() }
        inFlight = max(0, inFlight - 1)
        pump()
    }

    private func pendingCount() -> Int {
        // Track size alongside Queue in production; omitted for brevity in sketch.
        // Prefer storing `var size` on Queue.
        0 // replace with real size field
    }

    private func pump() {
        while inFlight < maxInFlight, let next = pending.dequeue() {
            inFlight += 1
            execute(next)
        }
    }
}
