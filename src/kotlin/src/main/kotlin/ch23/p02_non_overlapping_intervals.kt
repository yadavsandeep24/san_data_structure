// P2: Non-overlapping intervals
// Source: solutions/ch23/README.md
package ch23.p02_non_overlapping_intervals

fun eraseOverlapIntervals(intervals: Array<IntArray>): Int {
    if (intervals.isEmpty()) return 0
    intervals.sortBy { it[1] }
    var keptEnd = intervals[0][1]
    var removals = 0
    for (i in 1 until intervals.size) {
        if (intervals[i][0] >= keptEnd) {
            keptEnd = intervals[i][1]
        } else {
            removals++
        }
    }
    return removals
}
