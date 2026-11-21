// Q15. Accounts Merge (Union-Find Hard)
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md

func accountsMerge(_ accounts: [[String]]) -> [[String]] {
    var parent: [String: String] = [:]
    var emailName: [String: String] = [:]
    func find(_ x: String) -> String {
        let p = parent[x] ?? x
        if p == x { return x }
        let root = find(p)
        parent[x] = root
        return root
    }
    func union(_ a: String, _ b: String) {
        parent[find(a)] = find(b)
    }
    for acc in accounts {
        guard let name = acc.first, acc.count > 1 else { continue }
        for e in acc.dropFirst() {
            if parent[e] == nil { parent[e] = e }
            emailName[e] = name
            union(acc[1], e)
        }
    }
    var groups: [String: [String]] = [:]
    for e in parent.keys { groups[find(e), default: []].append(e) }
    return groups.map { root, emails in [emailName[root] ?? ""] + emails.sorted() }
}
