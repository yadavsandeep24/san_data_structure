// Q9. Time Based Key-Value Store (Versioned Config Cache)
// Source: book/part-viii/33-stacks-binary-search.md
package ch33.q09_time_based_key_value_store

class TimeMap {
    private val store = HashMap<String, MutableList<Pair<Int, String>>>()

    // Timestamps for a key arrive in increasing order, so each list stays sorted.
    fun set(key: String, value: String, timestamp: Int) {
        store.getOrPut(key) { mutableListOf() }.add(timestamp to value)
    }

    fun get(key: String, timestamp: Int): String {
        val list = store[key] ?: return ""
        var lo = 0
        var hi = list.lastIndex
        var ans = ""
        while (lo <= hi) { // last entry with time <= timestamp
            val mid = lo + (hi - lo) / 2
            if (list[mid].first <= timestamp) {
                ans = list[mid].second
                lo = mid + 1
            } else {
                hi = mid - 1
            }
        }
        return ans
    }
}
