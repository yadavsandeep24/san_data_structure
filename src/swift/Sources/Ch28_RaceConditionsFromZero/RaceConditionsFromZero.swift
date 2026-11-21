// Race conditions from zero
// Source: book/part-vii/28-concurrency.md

// Shared without synchronization
final class UnsafeCounter {
    var count = 0
    func inc() { count += 1 } // race if called from many threads
}
