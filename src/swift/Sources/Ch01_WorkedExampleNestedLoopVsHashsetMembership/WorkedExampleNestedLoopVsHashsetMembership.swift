// Worked example: nested loop vs HashSet membership
// Source: book/part-i/01-why-data-structures-matter.md

// BAD — linear membership repeated per row
func isSelectedSlow(_ id: String, selected: [String]) -> Bool {
    for s in selected {            // O(m)
        if s == id { return true }
    }
    return false
}

// GOOD
func buildSelectedSet(_ selected: [String]) -> Set<String> {
    Set(selected)                  // O(m)
}

func isSelectedFast(_ id: String, selectedSet: Set<String>) -> Bool {
    selectedSet.contains(id)       // O(1) average
}
