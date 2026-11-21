// Q27. Meeting Rooms or Min Platforms (Heap)
// Source: book/part-viii/29-interview-questions-q21-q30.md
package ch29.q27_meeting_rooms_or_min_platforms

fun minMeetingRooms(intervals: Array<IntArray>): Int {
    if (intervals.isEmpty()) return 0
    intervals.sortBy { it[0] }
    val ends = java.util.PriorityQueue<Int>()
    ends.add(intervals[0][1])
    for (i in 1 until intervals.size) {
        if (intervals[i][0] >= ends.peek()) ends.poll()
        ends.add(intervals[i][1])
    }
    return ends.size
}
