// Tries for autocomplete
// Source: book/part-iii/10-trees-practical.md

final class Trie {
    private final class Node {
        var children: [Character: Node] = [:]
        var end = false
    }
    private let root = Node()

    func insert(_ word: String) {
        var n = root
        for c in word {
            if let next = n.children[c] {
                n = next
            } else {
                let next = Node()
                n.children[c] = next
                n = next
            }
        }
        n.end = true
    }

    func search(_ word: String) -> Bool {
        walk(word)?.end == true
    }

    func startsWith(_ prefix: String) -> Bool {
        walk(prefix) != nil
    }

    private func walk(_ s: String) -> Node? {
        var n = root
        for c in s {
            guard let next = n.children[c] else { return nil }
            n = next
        }
        return n
    }
}
