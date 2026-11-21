// Q4. Integer Square Root without Floating Point (Thumbnail Grid)
// Source: book/part-viii/37-math-and-number-drills.md
package ch37.q04_integer_square_root_without_floating_point

fun isqrt(x: Long): Long {
    require(x >= 0)
    var lo = 0L
    var hi = minOf(x, 3_037_000_499L)                   // largest r whose square fits in a Long
    while (lo < hi) {
        val mid = lo + (hi - lo + 1) / 2                // round up so the loop always shrinks
        if (mid <= x / mid) lo = mid else hi = mid - 1  // mid * mid <= x, without overflow
    }
    return lo
}
