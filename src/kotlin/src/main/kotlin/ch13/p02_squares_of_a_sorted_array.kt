// P2: Squares of a sorted array
// Source: solutions/ch13/README.md
package ch13.p02_squares_of_a_sorted_array

fun sortedSquares(a: IntArray): IntArray {
    val out = IntArray(a.size)
    var lo = 0
    var hi = a.size - 1
    for (pos in a.size - 1 downTo 0) {
        val l = a[lo] * a[lo]
        val h = a[hi] * a[hi]
        if (l > h) { out[pos] = l; lo++ } else { out[pos] = h; hi-- }
    }
    return out
}
