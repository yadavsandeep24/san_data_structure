// Q19. Design Hit Counter (Rate Limit Window)
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md

final class HitCounter {
    private var q: [Int] = []
    func hit(_ timestamp: Int) { q.append(timestamp) }
    func getHits(_ timestamp: Int) -> Int {
        while let f = q.first, f <= timestamp - 300 { q.removeFirst() }
        return q.count
    }
}
