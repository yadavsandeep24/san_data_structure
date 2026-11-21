// Climbing stairs
// Source: book/part-vi/24-dynamic-programming.md
package ch24.climbing_stairs

fun climbStairs(n: Int): Int {
    if (n <= 2) return n
    var a = 1
    var b = 2
    for (i in 3..n) {
        val c = a + b
        a = b
        b = c
    }
    return b
}
