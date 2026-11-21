// Q35. Implement Trie (Autocomplete Core)
// Source: book/part-viii/29-interview-questions-q31-q40.md

final class Trie {
    private class Node { var next: [Character: Node] = [:]; var end = false }
    private let root = Node()
    func insert(_ word: String) {
        var n = root
        for c in word { n = n.next[c] ?? { let x = Node(); n.next[c] = x; return x }() }
        n.end = true
    }
    func search(_ word: String) -> Bool {
        var n: Node? = root
        for c in word { guard let nx = n?.next[c] else { return false }; n = nx }
        return n?.end ?? false
    }
    func startsWith(_ prefix: String) -> Bool {
        var n: Node? = root
        for c in prefix { guard let nx = n?.next[c] else { return false }; n = nx }
        return true
    }
}
