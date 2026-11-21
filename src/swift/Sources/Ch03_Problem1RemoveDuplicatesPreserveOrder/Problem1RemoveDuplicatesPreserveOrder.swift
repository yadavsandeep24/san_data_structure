// Problem 1 — Remove duplicates, preserve order
// Source: solutions/ch03/README.md

func removeDuplicatesPreserveOrder(_ ids: [String]) -> [String] {
    var seen = Set<String>()                     // O(u) space
    var out: [String] = []
    out.reserveCapacity(ids.count)
    for id in ids {                              // Θ(n)
        if seen.insert(id).inserted {            // O(1) average
            out.append(id)                       // O(1) amortized
        }
    }
    return out
}

// removeDuplicatesPreserveOrder(["a", "b", "a", "c", "b"]) == ["a", "b", "c"]
