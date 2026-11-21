// P1. LRU Image Memory Cache
// Source: solutions/ch38/README.md
package ch38.p01_lru_image_memory_cache

class ImageLruCache(private val capacity: Int) {
    private class Node(val key: String, var bytes: ByteArray) {
        var prev: Node? = null; var next: Node? = null
    }
    private val map = HashMap<String, Node>()
    private val head = Node("", ByteArray(0))
    private val tail = Node("", ByteArray(0))
    init { head.next = tail; tail.prev = head }

    private fun remove(n: Node) { n.prev!!.next = n.next; n.next!!.prev = n.prev }
    private fun addFront(n: Node) {
        n.next = head.next; n.prev = head
        head.next!!.prev = n; head.next = n
    }

    fun get(key: String): ByteArray? {
        val n = map[key] ?: return null
        remove(n); addFront(n); return n.bytes
    }
    fun put(key: String, bytes: ByteArray) {
        map[key]?.let { remove(it); map.remove(key) }
        val n = Node(key, bytes); addFront(n); map[key] = n
        if (map.size > capacity) {
            val lru = tail.prev!!; remove(lru); map.remove(lru.key)
        }
    }
}
