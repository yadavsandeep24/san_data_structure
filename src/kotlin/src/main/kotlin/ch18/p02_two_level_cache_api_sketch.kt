// P2: Two-level (memory + disk) cache API sketch
// Source: solutions/ch18/README.md
package ch18.p02_two_level_cache_api_sketch

interface MemoryCache<K, V> {
    fun get(key: K): V?
    fun put(key: K, value: V)
    fun remove(key: K)
    fun trimToHalf()
    fun clear()
}

interface DiskCache<K, V> {
    fun get(key: K): V?
    fun put(key: K, value: V)
    fun remove(key: K)
}

class MapMemoryCache<K, V>(private val capacity: Int) : MemoryCache<K, V> {
    private val map = object : LinkedHashMap<K, V>(capacity, 0.75f, true) {
        override fun removeEldestEntry(eldest: MutableMap.MutableEntry<K, V>?) = size > capacity
    }
    override fun get(key: K) = map[key]
    override fun put(key: K, value: V) { map[key] = value }
    override fun remove(key: K) { map.remove(key) }
    override fun clear() = map.clear()
    override fun trimToHalf() {
        val target = map.size / 2
        val it = map.entries.iterator()
        var seen = 0
        val n = map.size
        while (it.hasNext() && seen < n - target) {
            it.next(); it.remove(); seen++
        }
    }
}

class MapDiskCache<K, V> : DiskCache<K, V> {
    private val map = HashMap<K, V>()
    override fun get(key: K) = map[key]
    override fun put(key: K, value: V) { map[key] = value }
    override fun remove(key: K) { map.remove(key) }
}

enum class TrimLevel { MILD, CRITICAL }

class TwoLevelCache<K, V>(
    private val memory: MemoryCache<K, V>,
    private val disk: DiskCache<K, V>,
) {
    fun get(key: K): V? {
        memory.get(key)?.let { return it }
        val fromDisk = disk.get(key) ?: return null
        memory.put(key, fromDisk) // promote
        return fromDisk
    }

    fun put(key: K, value: V) {
        memory.put(key, value)
        disk.put(key, value)
    }

    fun invalidate(key: K) {
        memory.remove(key)
        disk.remove(key)
    }

    fun trimMemory(level: TrimLevel) {
        when (level) {
            TrimLevel.MILD -> memory.trimToHalf()
            TrimLevel.CRITICAL -> memory.clear()
        }
    }
}
