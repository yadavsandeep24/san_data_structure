// Q4. Design Add and Search Words Data Structure (Wildcard Contact Search)
// Source: book/part-viii/35-heaps-tries-greedy.md

final class TrieNode {
    var next: [Character: TrieNode] = [:]
    var end = false
}

final class WordDictionary {
    private let root = TrieNode()

    func addWord(_ word: String) {
        var cur = root
        for c in word {
            if let nx = cur.next[c] {
                cur = nx
            } else {
                let nx = TrieNode()
                cur.next[c] = nx
                cur = nx
            }
        }
        cur.end = true
    }

    func search(_ word: String) -> Bool {
        let chars = Array(word)
        func match(_ i: Int, _ node: TrieNode) -> Bool {
            if i == chars.count { return node.end }
            if chars[i] != "." {
                guard let nx = node.next[chars[i]] else { return false }
                return match(i + 1, nx)
            }
            return node.next.values.contains { match(i + 1, $0) }
        }
        return match(0, root)
    }
}
