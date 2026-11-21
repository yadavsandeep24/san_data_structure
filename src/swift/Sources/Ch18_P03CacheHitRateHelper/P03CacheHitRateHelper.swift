// P3: Cache hit-rate helper
// Source: solutions/ch18/README.md

final class HitRateCounter {
    private(set) var hits: Int = 0
    private(set) var misses: Int = 0

    func recordHit() { hits += 1 }
    func recordMiss() { misses += 1 }

    func hitRate() -> Double {
        let t = hits + misses
        return t == 0 ? 0 : Double(hits) / Double(t)
    }
}
