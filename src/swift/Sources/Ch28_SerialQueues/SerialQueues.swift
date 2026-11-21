// Serial queues
// Source: book/part-vii/28-concurrency.md
import Foundation

final class Counter {
    private let queue = DispatchQueue(label: "counter.serial")
    private var value = 0
    func increment() {
        queue.sync { value += 1 }
    }
    func get() -> Int {
        queue.sync { value }
    }
}
