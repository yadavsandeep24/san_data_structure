// P2. Autocomplete Trie
// Source: solutions/ch38/README.md

final class AutoComplete {
    private class Node { var kids: [Character: Node] = [:]; var end = false }
    private let root = Node()
    func insert(_ word: String) {
        var n = root
        for c in word.lowercased() {
            if n.kids[c] == nil { n.kids[c] = Node() }
            n = n.kids[c]!
        }
        n.end = true
    }
    func suggest(_ prefix: String, _ k: Int) -> [String] {
        var n: Node? = root
        let p = prefix.lowercased()
        for c in p { guard let nx = n?.kids[c] else { return [] }; n = nx }
        var out: [String] = []
        func dfs(_ cur: Node, _ path: inout String) {
            if out.count >= k { return }
            if cur.end { out.append(path) }
            for (ch, child) in cur.kids.sorted(by: { $0.key < $1.key }) {
                path.append(ch); dfs(child, &path); path.removeLast()
                if out.count >= k { return }
            }
        }
        var path = p; dfs(n!, &path); return out
    }
}
