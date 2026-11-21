// P2. Autocomplete Trie
// Source: solutions/ch38/README.md
package ch38.p02_autocomplete_trie

class AutoComplete {
    private class Node {
        val kids = HashMap<Char, Node>()
        var end = false
    }
    private val root = Node()
    fun insert(word: String) {
        var n = root
        for (c in word.lowercase()) n = n.kids.getOrPut(c) { Node() }
        n.end = true
    }
    fun suggest(prefix: String, k: Int): List<String> {
        var n: Node? = root
        for (c in prefix.lowercase()) { n = n?.kids[c] ?: return emptyList() }
        val out = mutableListOf<String>()
        fun dfs(cur: Node, path: StringBuilder) {
            if (out.size >= k) return
            if (cur.end) out.add(path.toString())
            for ((ch, child) in cur.kids) {
                path.append(ch); dfs(child, path); path.deleteCharAt(path.lastIndex)
                if (out.size >= k) return
            }
        }
        dfs(n!!, StringBuilder(prefix.lowercase()))
        return out
    }
}
