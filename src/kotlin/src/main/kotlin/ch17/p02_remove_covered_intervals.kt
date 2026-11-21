// P2: Remove covered intervals
// Source: solutions/ch17/README.md
package ch17.p02_remove_covered_intervals

fun removeCoveredIntervals(intervals: List<IntArray>): Int {
    val sorted = intervals.sortedWith(compareBy<IntArray>({ it[0] }, { -it[1] }))
    var maxEnd = Int.MIN_VALUE
    var kept = 0
    for ((_, end) in sorted) {
        if (end > maxEnd) {
            kept++
            maxEnd = end
        }
    }
    return kept
}
