// P2: Implement Trie
// Source: solutions/ch10/README.md

final class Trie {
    private final class Node {
        var children: [Character: Node] = [:]
        var end = false
    }
    private let root = Node()

    func insert(_ word: String) {
        var n = root
        for c in word {
            if n.children[c] == nil { n.children[c] = Node() }
            n = n.children[c]!
        }
        n.end = true
    }

    func search(_ word: String) -> Bool { walk(word)?.end == true }

    func startsWith(_ prefix: String) -> Bool { walk(prefix) != nil }

    private func walk(_ s: String) -> Node? {
        var n = root
        for c in s {
            guard let next = n.children[c] else { return nil }
            n = next
        }
        return n
    }
}
