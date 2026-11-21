// Q36. LRU Cache
// Source: book/part-viii/29-interview-questions-q31-q40.md
package ch29.q36_lru_cache

class LRUCache(private val capacity: Int) {
    private class Node(val key: Int, var value: Int) {
        var prev: Node? = null; var next: Node? = null
    }
    private val map = HashMap<Int, Node>()
    private val head = Node(0, 0)
    private val tail = Node(0, 0)
    init { head.next = tail; tail.prev = head }
    private fun remove(n: Node) { n.prev!!.next = n.next; n.next!!.prev = n.prev }
    private fun addFront(n: Node) {
        n.next = head.next; n.prev = head
        head.next!!.prev = n; head.next = n
    }
    fun get(key: Int): Int {
        val n = map[key] ?: return -1
        remove(n); addFront(n); return n.value
    }
    fun put(key: Int, value: Int) {
        map[key]?.let { remove(it); map.remove(key) }
        val n = Node(key, value); addFront(n); map[key] = n
        if (map.size > capacity) {
            val lru = tail.prev!!; remove(lru); map.remove(lru.key)
        }
    }
}
