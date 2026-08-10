// Sample: order-preserving unique IDs (Chapter 3)
func uniquePreserveOrder(_ ids: [String]) -> [String] {
    var seen = Set<String>()
    var out: [String] = []
    out.reserveCapacity(ids.count)
    for id in ids {
        if seen.insert(id).inserted {
            out.append(id)
        }
    }
    return out
}
