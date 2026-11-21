// Q35. Implement Trie (Autocomplete Core)
// Source: book/part-viii/29-interview-questions-q31-q40.md
package ch29.q35_implement_trie

class Trie {
    private class Node { val next = HashMap<Char, Node>(); var end = false }
    private val root = Node()
    fun insert(word: String) {
        var n = root
        for (c in word) n = n.next.getOrPut(c) { Node() }
        n.end = true
    }
    fun search(word: String): Boolean {
        var n: Node? = root
        for (c in word) { n = n!!.next[c] ?: return false }
        return n!!.end
    }
    fun startsWith(prefix: String): Boolean {
        var n: Node? = root
        for (c in prefix) { n = n!!.next[c] ?: return false }
        return true
    }
}
