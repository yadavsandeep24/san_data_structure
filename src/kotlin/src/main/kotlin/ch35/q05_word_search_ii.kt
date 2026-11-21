// Q5. Word Search II (Word Game Board Scan)
// Source: book/part-viii/35-heaps-tries-greedy.md
package ch35.q05_word_search_ii

fun findWords(board: Array<CharArray>, words: Array<String>): List<String> {
    class Node {
        val next = arrayOfNulls<Node>(26)
        var word: String? = null
    }
    val root = Node()
    for (w in words) {
        var cur = root
        for (c in w) cur = cur.next[c - 'a'] ?: Node().also { cur.next[c - 'a'] = it }
        cur.word = w
    }
    val rows = board.size
    val cols = board[0].size
    val found = mutableListOf<String>()
    fun dfs(r: Int, c: Int, parent: Node) {
        val ch = board[r][c]
        if (ch == '#') return
        val node = parent.next[ch - 'a'] ?: return
        node.word?.let { found += it; node.word = null } // report once
        board[r][c] = '#'
        if (r > 0) dfs(r - 1, c, node)
        if (r < rows - 1) dfs(r + 1, c, node)
        if (c > 0) dfs(r, c - 1, node)
        if (c < cols - 1) dfs(r, c + 1, node)
        board[r][c] = ch
    }
    for (r in 0 until rows) for (c in 0 until cols) dfs(r, c, root)
    return found
}
