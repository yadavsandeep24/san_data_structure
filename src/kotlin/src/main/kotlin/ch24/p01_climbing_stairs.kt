// P1: Climbing stairs
// Source: solutions/ch24/README.md
package ch24.p01_climbing_stairs

fun climbStairs(n: Int): Int {
    if (n <= 2) return n
    var a = 1
    var b = 2
    repeat(n - 2) {
        val c = a + b
        a = b
        b = c
    }
    return b
}
