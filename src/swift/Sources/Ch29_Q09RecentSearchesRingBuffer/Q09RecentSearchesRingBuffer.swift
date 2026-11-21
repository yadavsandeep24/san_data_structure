// Q9. Recent Searches Ring Buffer
// Source: book/part-viii/29-interview-questions-q01-q10.md

final class RecentSearches {
    private let k: Int
    private var q: [String] = []
    private var head = 0
    private var seen = Set<String>()
    init(_ k: Int) { self.k = k }
    func add(_ term: String) {
        if seen.contains(term) {
            if let i = q[head...].firstIndex(of: term) { q.remove(at: i) }
        } else {
            seen.insert(term)
        }
        q.append(term)
        while q.count - head > k {
            seen.remove(q[head]); head += 1
        }
    }
    func list() -> [String] { Array(q[head...].reversed()) }
}
