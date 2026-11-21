// Q8. Merge Intervals and Insert Interval Combo
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md
package ch30.q08_merge_intervals_and_insert_interval_combo

fun merge(intervals: Array<IntArray>): Array<IntArray> {
    if (intervals.isEmpty()) return emptyArray()
    intervals.sortBy { it[0] }
    val out = mutableListOf(intervals[0].clone())
    for (i in 1 until intervals.size) {
        val last = out.last()
        val cur = intervals[i]
        if (cur[0] <= last[1]) last[1] = maxOf(last[1], cur[1])
        else out += cur.clone()
    }
    return out.toTypedArray()
}

fun insert(intervals: Array<IntArray>, newInterval: IntArray): Array<IntArray> {
    val out = mutableListOf<IntArray>()
    var i = 0
    val n = intervals.size
    var ns = newInterval[0]
    var ne = newInterval[1]
    while (i < n && intervals[i][1] < ns) out += intervals[i++]
    while (i < n && intervals[i][0] <= ne) {
        ns = minOf(ns, intervals[i][0])
        ne = maxOf(ne, intervals[i][1])
        i++
    }
    out += intArrayOf(ns, ne)
    while (i < n) out += intervals[i++]
    return out.toTypedArray()
}
