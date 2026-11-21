// Q5 — Word Search II (Swift / Dart)
// Source: solutions/ch35/README.md

final class WordNode {
    var next: [Character: WordNode] = [:]
    var word: String?
}

func findWords(_ board: [[Character]], _ words: [String]) -> [String] {
    let root = WordNode()
    for w in words {
        var cur = root
        for c in w {
            if let nx = cur.next[c] {
                cur = nx
            } else {
                let nx = WordNode()
                cur.next[c] = nx
                cur = nx
            }
        }
        cur.word = w
    }
    var grid = board // local copy; Swift arrays are values
    let rows = grid.count, cols = grid.first?.count ?? 0
    var found: [String] = []
    func dfs(_ r: Int, _ c: Int, _ parent: WordNode) {
        let ch = grid[r][c]
        guard let node = parent.next[ch] else { return } // '#' is never a trie edge
        if let w = node.word {
            found.append(w)
            node.word = nil // report once
        }
        grid[r][c] = "#"
        if r > 0 { dfs(r - 1, c, node) }
        if r < rows - 1 { dfs(r + 1, c, node) }
        if c > 0 { dfs(r, c - 1, node) }
        if c < cols - 1 { dfs(r, c + 1, node) }
        grid[r][c] = ch
    }
    for r in 0..<rows { for c in 0..<cols { dfs(r, c, root) } }
    return found
}
