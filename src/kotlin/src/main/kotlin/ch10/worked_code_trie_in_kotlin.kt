// Worked code: Trie in Kotlin
// Source: book/part-iii/10-trees-practical.md
package ch10.worked_code_trie_in_kotlin

class Trie {
    private class Node {
        val children = HashMap<Char, Node>()
        var end = false
    }
    private val root = Node()

    fun insert(word: String) {
        var n = root
        for (c in word) {
            n = n.children.getOrPut(c) { Node() }
        }
        n.end = true
    }

    fun search(word: String): Boolean =
        walk(word)?.end == true

    fun startsWith(prefix: String): Boolean =
        walk(prefix) != null

    private fun walk(s: String): Node? {
        var n = root
        for (c in s) {
            n = n.children[c] ?: return null
        }
        return n
    }
}
