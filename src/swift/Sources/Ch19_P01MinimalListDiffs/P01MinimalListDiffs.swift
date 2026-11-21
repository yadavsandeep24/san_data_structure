// P1: Minimal list diffs (insert / remove / update)
// Source: solutions/ch19/README.md

struct Row: Equatable {
    let id: String
    let value: String
}

enum Edit: Equatable {
    case insert(index: Int, id: String)
    case remove(id: String)
    case update(id: String)
}

func minimalDiff(old: [Row], new: [Row]) -> [Edit] {
    let oldMap = Dictionary(uniqueKeysWithValues: old.map { ($0.id, $0) })
    let newIds = Set(new.map(\.id))
    var edits: [Edit] = []
    for o in old where !newIds.contains(o.id) {
        edits.append(.remove(id: o.id))
    }
    for (index, n) in new.enumerated() {
        if let prev = oldMap[n.id] {
            if prev.value != n.value { edits.append(.update(id: n.id)) }
        } else {
            edits.append(.insert(index: index, id: n.id))
        }
    }
    return edits
}
