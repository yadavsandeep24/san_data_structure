// P3: Sum of subarray minimums
// Source: solutions/ch16/README.md
package ch16.p03_sum_of_subarray_minimums

fun sumSubarrayMins(a: IntArray): Int {
    val mod = 1_000_000_007L
    val stack = ArrayDeque<Int>()
    var total = 0L
    for (i in 0..a.size) {
        val cur = if (i == a.size) Int.MIN_VALUE else a[i]
        while (stack.isNotEmpty() && a[stack.last()] >= cur) {
            val j = stack.removeLast()
            val k = if (stack.isEmpty()) -1 else stack.last()
            total = (total + a[j].toLong() * (j - k) * (i - j)) % mod
        }
        stack.addLast(i)
    }
    return total.toInt()
}
