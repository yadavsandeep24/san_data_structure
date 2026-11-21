// P3. Offline-First Feed
// Source: solutions/ch38/README.md

struct Entity: Equatable { let id: String; var body: String }
final class FeedBuffer {
    private(set) var items: [Entity] = []
    private var index: [String: Int] = [:]
    func applyPage(_ page: [Entity], prepend: Bool) {
        let fresh = page.filter { index[$0.id] == nil }
        items = prepend ? fresh + items : items + fresh
        reindex()
    }
    private func reindex() {
        index = Dictionary(uniqueKeysWithValues: items.enumerated().map { ($0.element.id, $0.offset) })
    }
}
