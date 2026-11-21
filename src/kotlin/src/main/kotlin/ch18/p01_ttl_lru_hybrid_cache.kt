// P1: TTL + LRU hybrid cache
// Source: solutions/ch18/README.md
package ch18.p01_ttl_lru_hybrid_cache

import ch18.worked_examples.Entry

class TtlLruCache<K, V>(
    private val capacity: Int,
    private val clock: () -> Long = { System.currentTimeMillis() },
) {
    private data class Entry<V>(val value: V, val expiresAt: Long)

    private val map = object : LinkedHashMap<K, Entry<V>>(capacity, 0.75f, true) {
        override fun removeEldestEntry(eldest: MutableMap.MutableEntry<K, Entry<V>>?): Boolean =
            size > capacity
    }

    @Synchronized
    fun get(key: K): V? {
        val e = map[key] ?: return null
        if (clock() >= e.expiresAt) {
            map.remove(key)
            return null
        }
        return e.value // accessOrder already touched by get
    }

    @Synchronized
    fun put(key: K, value: V, ttlMillis: Long) {
        require(capacity >= 1)
        map[key] = Entry(value, clock() + ttlMillis)
        // removeEldestEntry handles capacity
    }

    @Synchronized
    fun size(): Int = map.size
}
