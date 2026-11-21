// Worked examples (four languages)
// Source: book/part-i/02-big-o-notation.md

func frequencies(_ ids: [String]) -> [String: Int] {
    var counts: [String: Int] = [:]               // O(u) space
    for id in ids {                               // Θ(n)
        counts[id, default: 0] += 1               // O(1) average
    }
    return counts
}
