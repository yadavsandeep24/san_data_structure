// Q11. Minimum Number of Arrows to Burst Balloons (Fewest Sync Ticks)
// Source: book/part-viii/32-two-pointers-windows-intervals.md
package ch32.q11_minimum_number_of_arrows_to_burst_balloons

fun findMinArrowShots(points: Array<IntArray>): Int {
    if (points.isEmpty()) return 0
    val sorted = points.sortedBy { it[1] }
    var arrows = 1
    var arrowX = sorted[0][1]
    for (p in sorted) {
        if (p[0] > arrowX) {
            arrows++
            arrowX = p[1]
        }
    }
    return arrows
}
