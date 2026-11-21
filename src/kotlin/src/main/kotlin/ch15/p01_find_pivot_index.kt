// P1: Find pivot index
// Source: solutions/ch15/README.md
package ch15.p01_find_pivot_index

fun pivotIndex(a: IntArray): Int {
    val total = a.sumOf { it.toLong() }
    var left = 0L
    for (i in a.indices) {
        if (left == total - left - a[i]) return i
        left += a[i]
    }
    return -1
}
