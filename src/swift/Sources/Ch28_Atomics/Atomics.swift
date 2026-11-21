// Atomics
// Source: book/part-vii/28-concurrency.md
import Synchronization

let count = Atomic<Int>(0) // iOS 18+ / macOS 15+; older SDKs: OSAllocatedUnfairLock
func example() {
    count.add(1, ordering: .relaxed)
}
