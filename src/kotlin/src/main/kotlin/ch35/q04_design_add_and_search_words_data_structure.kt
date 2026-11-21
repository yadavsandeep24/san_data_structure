// Q4. Design Add and Search Words Data Structure (Wildcard Contact Search)
// Source: book/part-viii/35-heaps-tries-greedy.md
package ch35.q04_design_add_and_search_words_data_structure

class WordDictionary {
    private class Node {
        val next = arrayOfNulls<Node>(26)
        var end = false
    }

    private val root = Node()

    fun addWord(word: String) {
        var cur = root
        for (c in word) {
            val i = c - 'a'
            cur = cur.next[i] ?: Node().also { cur.next[i] = it }
        }
        cur.end = true
    }

    fun search(word: String): Boolean = match(word, 0, root)

    private fun match(w: String, i: Int, node: Node): Boolean {
        if (i == w.length) return node.end
        val c = w[i]
        if (c != '.') {
            val nx = node.next[c - 'a'] ?: return false
            return match(w, i + 1, nx)
        }
        return node.next.any { it != null && match(w, i + 1, it) }
    }
}
