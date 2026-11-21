// Platform bridges
// Source: book/part-iii/08-sets.md

final class SelectionTracker {
    private var order: [String] = []     // tap order
    private var selected: Set<String> = []

    func toggle(_ id: String) {
        if selected.insert(id).inserted {
            order.append(id)
        } else {
            selected.remove(id)
            order.removeAll { $0 == id }  // O(n) only on deselect
        }
    }

    func isSelected(_ id: String) -> Bool { selected.contains(id) }
    func snapshot() -> [String] { order }
}
