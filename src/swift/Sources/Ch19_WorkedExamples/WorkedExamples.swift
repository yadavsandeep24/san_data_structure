// Worked examples (four languages)
// Source: book/part-v/19-efficient-list-rendering.md

struct FeedItem: Hashable {
    let id: String
    let title: String
}
// DiffableDataSource item identifier: item.id

enum ListEdit: Equatable {
    case insert(index: Int, id: String)
    case remove(id: String)
    case update(id: String)
}

struct Item {
    let id: String
    let body: String
}

func diff(_ old: [Item], _ new: [Item]) -> [ListEdit] {
    let oldMap = Dictionary(old.map { ($0.id, $0) }, uniquingKeysWith: { _, last in last })
    let newIds = Set(new.map(\.id))
    var edits: [ListEdit] = []
    for o in old where !newIds.contains(o.id) { edits.append(.remove(id: o.id)) }
    for (index, n) in new.enumerated() {
        if let prev = oldMap[n.id] {
            if prev.body != n.body { edits.append(.update(id: n.id)) }
        } else {
            edits.append(.insert(index: index, id: n.id))
        }
    }
    return edits
}

func appendPage(
    _ buffer: [FeedItem],
    _ seen: inout Set<String>,
    _ page: [FeedItem]
) -> [FeedItem] {
    var next = buffer
    for item in page where seen.insert(item.id).inserted {
        next.append(item)
    }
    return next
}
