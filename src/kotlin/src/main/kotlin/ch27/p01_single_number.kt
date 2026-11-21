// P1: Single number
// Source: solutions/ch27/README.md
package ch27.p01_single_number

fun singleNumber(nums: IntArray): Int =
    nums.fold(0) { acc, x -> acc xor x }
