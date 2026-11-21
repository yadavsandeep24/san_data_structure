// Q7. Alien Dictionary (Harder Graph Variant)
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md

func alienOrder(_ words: [String]) -> String {
    var adj: [Character: Set<Character>] = [:]
    var indeg: [Character: Int] = [:]
    for w in words {
        for c in w where adj[c] == nil {
            adj[c] = []
            indeg[c] = 0
        }
    }
    for (a, b) in zip(words, words.dropFirst()) {
        if a.count > b.count && a.hasPrefix(b) { return "" }
        for (x, y) in zip(a, b) where x != y {
            if adj[x, default: []].insert(y).inserted { indeg[y, default: 0] += 1 }
            break
        }
    }
    var q = indeg.filter { $0.value == 0 }.map(\.key)
    var head = 0
    var out = ""
    while head < q.count {
        let u = q[head]
        head += 1
        out.append(u)
        for v in adj[u, default: []] {
            indeg[v, default: 0] -= 1
            if indeg[v] == 0 { q.append(v) }
        }
    }
    return out.count == indeg.count ? out : ""
}
