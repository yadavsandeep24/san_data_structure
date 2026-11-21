// P1: Membership under scroll
// Source: solutions/ch01/README.md

func countSelectedVisible(_ visibleIds: [String], _ selectedIds: [String]) -> Int {
    let selected = Set(selectedIds)
    return visibleIds.reduce(0) { $0 + (selected.contains($1) ? 1 : 0) }
}
