// Q9. LFU Cache
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md
package ch30.q09_lfu_cache

class LFUCache(private val capacity: Int) {
    private data class Node(val key: Int, var value: Int, var freq: Int = 1)
    private val keyNode = HashMap<Int, Node>()
    private val freqList = HashMap<Int, LinkedHashSet<Int>>()
    private var minFreq = 0

    fun get(key: Int): Int {
        val n = keyNode[key] ?: return -1
        touch(n)
        return n.value
    }

    fun put(key: Int, value: Int) {
        if (capacity == 0) return
        keyNode[key]?.let {
            it.value = value
            touch(it)
            return
        }
        if (keyNode.size >= capacity) {
            val set = freqList[minFreq]!!
            val evict = set.iterator().next()
            set.remove(evict)
            keyNode.remove(evict)
        }
        val n = Node(key, value)
        keyNode[key] = n
        freqList.getOrPut(1) { LinkedHashSet() }.add(key)
        minFreq = 1
    }

    private fun touch(n: Node) {
        val f = n.freq
        freqList[f]!!.remove(n.key)
        if (freqList[f]!!.isEmpty()) {
            freqList.remove(f)
            if (minFreq == f) minFreq++
        }
        n.freq = f + 1
        freqList.getOrPut(n.freq) { LinkedHashSet() }.add(n.key)
    }
}
