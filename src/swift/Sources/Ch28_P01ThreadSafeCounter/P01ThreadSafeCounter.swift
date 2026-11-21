// P1: Thread-safe counter
// Source: solutions/ch28/README.md
import Foundation

actor SafeCounter {
    private var value = 0
    func increment() -> Int {
        value += 1
        return value
    }
    func get() -> Int { value }
}

final class QueueCounter {
    private let queue = DispatchQueue(label: "counter.serial")
    private var value = 0
    @discardableResult
    func increment() -> Int {
        queue.sync {
            value += 1
            return value
        }
    }
    func get() -> Int { queue.sync { value } }
}
