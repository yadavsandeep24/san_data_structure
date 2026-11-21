// LRU cache: HashMap and doubly linked list
// Source: book/part-ii/04-linked-lists.md
package ch04.lru_cache_hashmap_and_doubly_linked_list

class LRUCache(private val capacity: Int) {
    private class Node(val key: Int, var value: Int) {
        var prev: Node? = null
        var next: Node? = null
    }

    private val map = HashMap<Int, Node>()
    private val head = Node(-1, -1)
    private val tail = Node(-1, -1)

    init {
        head.next = tail
        tail.prev = head
    }

    fun get(key: Int): Int {
        val node = map[key] ?: return -1
        moveToHead(node)
        return node.value
    }

    fun put(key: Int, value: Int) {
        val existing = map[key]
        if (existing != null) {
            existing.value = value
            moveToHead(existing)
            return
        }
        val node = Node(key, value)
        map[key] = node
        addAfterHead(node)
        if (map.size > capacity) {
            val lru = popTail()
            map.remove(lru.key)
        }
    }

    private fun addAfterHead(node: Node) {
        node.prev = head
        node.next = head.next
        head.next!!.prev = node
        head.next = node
    }

    private fun remove(node: Node) {
        node.prev!!.next = node.next
        node.next!!.prev = node.prev
    }

    private fun moveToHead(node: Node) {
        remove(node)
        addAfterHead(node)
    }

    private fun popTail(): Node {
        val node = tail.prev!!
        remove(node)
        return node
    }
}
