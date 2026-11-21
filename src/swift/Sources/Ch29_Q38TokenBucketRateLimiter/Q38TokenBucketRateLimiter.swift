// Q38. Token Bucket Rate Limiter
// Source: book/part-viii/29-interview-questions-q31-q40.md
import Foundation

final class TokenBucket {
    private let rate: Double, capacity: Double
    private var tokens: Double
    private var last = ContinuousClock.now
    private let lock = NSLock()
    init(rate: Double, capacity: Double) {
        self.rate = rate; self.capacity = capacity; self.tokens = capacity
    }
    func allow() -> Bool {
        lock.lock(); defer { lock.unlock() }
        let now = ContinuousClock.now
        let d = last.duration(to: now)
        let elapsed = Double(d.components.seconds) + Double(d.components.attoseconds) / 1e18
        last = now
        tokens = min(capacity, tokens + elapsed * rate)
        guard tokens >= 1 else { return false }
        tokens -= 1; return true
    }
}
