// Worked examples (four languages)
// Source: book/part-v/18-caching-strategies.md
package ch18.worked_examples

class LruCache<K, V>(private val capacity: Int) :
    LinkedHashMap<K, V>(capacity, 0.75f, /* accessOrder = */ true) {

    override fun removeEldestEntry(eldest: MutableMap.MutableEntry<K, V>?): Boolean =
        size > capacity
}

fun demo() {
    val cache = LruCache<String, String>(2)
    cache["a"] = "1"
    cache["b"] = "2"
    cache["a"] // access → "a" becomes newest
    cache["c"] = "3" // evicts "b"
}

data class Entry<V>(val value: V, val expiresAtMillis: Long)

fun <V> getIfFresh(map: Map<String, Entry<V>>, key: String, now: Long): V? {
    val e = map[key] ?: return null
    if (now >= e.expiresAtMillis) return null // treat as miss
    return e.value
}
