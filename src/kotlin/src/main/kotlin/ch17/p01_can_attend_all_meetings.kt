// P1: Can attend all meetings
// Source: solutions/ch17/README.md
package ch17.p01_can_attend_all_meetings

fun canAttendAll(meetings: List<IntArray>): Boolean {
    val sorted = meetings.sortedBy { it[0] }
    for (i in 1 until sorted.size) {
        if (sorted[i][0] < sorted[i - 1][1]) return false
    }
    return true
}
