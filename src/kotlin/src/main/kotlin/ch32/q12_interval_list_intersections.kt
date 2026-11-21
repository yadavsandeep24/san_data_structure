// Q12. Interval List Intersections (Shared Free Slots)
// Source: book/part-viii/32-two-pointers-windows-intervals.md
package ch32.q12_interval_list_intersections

fun intervalIntersection(a: Array<IntArray>, b: Array<IntArray>): List<IntArray> {
    val out = mutableListOf<IntArray>()
    var i = 0
    var j = 0
    while (i < a.size && j < b.size) {
        val lo = maxOf(a[i][0], b[j][0])
        val hi = minOf(a[i][1], b[j][1])
        if (lo <= hi) out.add(intArrayOf(lo, hi))
        if (a[i][1] < b[j][1]) i++ else j++
    }
    return out
}
