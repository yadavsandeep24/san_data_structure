// Worked example 2: bookings per hour with a difference array
// Source: book/part-iv/15-prefix-sums.md
package ch15.worked_example_2_bookings_per_hour_with_a_differ

fun bookingsPerHour(hours: Int, bookings: List<IntArray>): IntArray {
    val diff = IntArray(hours + 1)
    for ((start, end) in bookings) {
        diff[start] += 1
        diff[end + 1] -= 1
    }
    val out = IntArray(hours)
    var running = 0
    for (h in 0 until hours) {
        running += diff[h]
        out[h] = running
    }
    return out
}
