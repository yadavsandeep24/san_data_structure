// Q28. Climbing Stairs
// Source: book/part-viii/29-interview-questions-q21-q30.md
package ch29.q28_climbing_stairs

fun climbStairs(n: Int): Int {
    if (n <= 2) return n
    var a = 1; var b = 2
    for (i in 3..n) {
        val c = a + b; a = b; b = c
    }
    return b
}
