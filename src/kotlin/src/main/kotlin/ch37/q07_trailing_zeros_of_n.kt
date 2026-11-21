// Q7. Trailing Zeros of n! (Big Number Sanity Check)
// Source: book/part-viii/37-math-and-number-drills.md
package ch37.q07_trailing_zeros_of_n

fun trailingZerosOfFactorial(n: Long): Long {
    var count = 0L
    var power = 5L
    while (power <= n) {
        count += n / power                              // multiples of 5, then extra 5s from 25, 125, ...
        if (power > Long.MAX_VALUE / 5) break           // next power would overflow a Long
        power *= 5
    }
    return count
}
