// P3: Meeting scheduler (two calendars)
// Source: solutions/ch17/README.md
package ch17.p03_meeting_scheduler

fun meetingScheduler(slotsA: List<IntArray>, slotsB: List<IntArray>, duration: Int): IntArray? {
    val a = slotsA.sortedBy { it[0] }
    val b = slotsB.sortedBy { it[0] }
    var i = 0
    var j = 0
    while (i < a.size && j < b.size) {
        val start = maxOf(a[i][0], b[j][0])
        val end = minOf(a[i][1], b[j][1])
        if (end - start >= duration) return intArrayOf(start, start + duration)
        if (a[i][1] < b[j][1]) i++ else j++
    }
    return null
}
