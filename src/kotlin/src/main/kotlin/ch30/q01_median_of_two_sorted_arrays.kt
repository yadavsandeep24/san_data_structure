// Q1. Median of Two Sorted Arrays (Fee Tier Cut)
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md
package ch30.q01_median_of_two_sorted_arrays

fun findMedianSortedArrays(a: IntArray, b: IntArray): Double {
    if (a.size > b.size) return findMedianSortedArrays(b, a)
    val m = a.size
    val n = b.size
    var lo = 0
    var hi = m
    val half = (m + n + 1) / 2
    while (lo <= hi) {
        val i = (lo + hi) / 2
        val j = half - i
        val aLeft = if (i == 0) Int.MIN_VALUE else a[i - 1]
        val aRight = if (i == m) Int.MAX_VALUE else a[i]
        val bLeft = if (j == 0) Int.MIN_VALUE else b[j - 1]
        val bRight = if (j == n) Int.MAX_VALUE else b[j]
        when {
            aLeft <= bRight && bLeft <= aRight -> {
                return if ((m + n) % 2 == 0)
                    (maxOf(aLeft, bLeft).toDouble() + minOf(aRight, bRight)) / 2.0
                else maxOf(aLeft, bLeft).toDouble()
            }
            aLeft > bRight -> hi = i - 1
            else -> lo = i + 1
        }
    }
    error("unreachable")
}
