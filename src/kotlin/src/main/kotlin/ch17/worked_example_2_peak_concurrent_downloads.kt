// Worked example 2: peak concurrent downloads (sweep line)
// Source: book/part-iv/17-intervals-sweep-line.md
package ch17.worked_example_2_peak_concurrent_downloads

fun peakConcurrent(intervals: List<IntArray>): Int {
    val events = ArrayList<IntArray>(intervals.size * 2)
    for ((s, e) in intervals) {
        events.add(intArrayOf(s, +1))
        events.add(intArrayOf(e, -1))
    }
    events.sortWith(compareBy<IntArray>({ it[0] }, { it[1] }))  // ends (-1) before starts at ties
    var active = 0
    var peak = 0
    for ((_, delta) in events) {
        active += delta
        peak = maxOf(peak, active)
    }
    return peak
}
