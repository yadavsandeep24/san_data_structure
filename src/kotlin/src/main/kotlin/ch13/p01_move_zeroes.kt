// P1: Move zeroes
// Source: solutions/ch13/README.md
package ch13.p01_move_zeroes

fun moveZeroes(a: IntArray) {
    var write = 0
    for (read in a.indices) {
        if (a[read] != 0) a[write++] = a[read]
    }
    while (write < a.size) a[write++] = 0
}
