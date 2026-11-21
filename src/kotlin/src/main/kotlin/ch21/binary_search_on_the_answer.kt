// Binary search on the answer
// Source: book/part-vi/21-searching-sorting.md
package ch21.binary_search_on_the_answer

fun minDailyQuota(files: IntArray, days: Int): Int {
    fun daysNeeded(quota: Int): Int {
        var used = 0
        var count = 1
        for (f in files) {
            if (used + f > quota) { count++; used = 0 }
            used += f
        }
        return count
    }
    var lo = files.max()
    var hi = files.sum()
    while (lo < hi) {
        val mid = lo + (hi - lo) / 2
        if (daysNeeded(mid) <= days) hi = mid else lo = mid + 1
    }
    return lo
}
