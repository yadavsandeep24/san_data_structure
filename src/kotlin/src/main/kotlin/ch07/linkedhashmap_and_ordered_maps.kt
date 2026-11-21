// LinkedHashMap and ordered maps
// Source: book/part-iii/07-hash-tables.md
package ch07.linkedhashmap_and_ordered_maps

// Sketch: id → node, plus doubly linked list for LRU order (Chapter 18 expands this)
class LruSketch<K, V>(private val capacity: Int) {
    private val map = LinkedHashMap<K, V>(capacity, 0.75f, /* accessOrder */ true)
    fun get(key: K): V? = map[key]
    fun put(key: K, value: V) {
        map[key] = value
        if (map.size > capacity) {
            val eldest = map.entries.iterator().next()
            map.remove(eldest.key)
        }
    }
}
