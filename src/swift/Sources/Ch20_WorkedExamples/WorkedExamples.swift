// Worked examples
// Source: book/part-v/20-decision-guide.md

final class Cart {
    private var order: [String] = []
    private var qty: [String: Int] = [:]

    func add(_ sku: String) {
        let n = qty[sku] ?? 0
        if n == 0 { order.append(sku) }
        qty[sku] = n + 1
    }

    func contains(_ sku: String) -> Bool { qty[sku] != nil }

    func lines() -> [(String, Int)] {
        order.map { ($0, qty[$0]!) }
    }
}

final class RecentSearches {
    private var q: [String] = []
    private var head = 0
    private var seen = Set<String>()
    private let k: Int

    init(k: Int) { self.k = k }

    func add(_ term: String) {
        if seen.contains(term) {
            if let i = q[head...].firstIndex(of: term) { q.remove(at: i) }
        } else {
            seen.insert(term)
        }
        q.append(term)
        while q.count - head > k {
            seen.remove(q[head])
            head += 1
        }
    }

    func list() -> [String] { Array(q[head...].reversed()) }
}
