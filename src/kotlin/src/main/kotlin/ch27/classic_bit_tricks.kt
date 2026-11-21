// Classic bit tricks
// Source: book/part-vii/27-bits-matrix.md
package ch27.classic_bit_tricks

fun singleNumber(nums: IntArray): Int =
    nums.fold(0) { acc, x -> acc xor x }

fun isPowerOfTwo(n: Int): Boolean =
    n > 0 && (n and (n - 1)) == 0

fun hammingWeight(n: Int): Int {
    var c = 0
    var x = n
    while (x != 0) {
        x = x and (x - 1)
        c++
    }
    return c
}
