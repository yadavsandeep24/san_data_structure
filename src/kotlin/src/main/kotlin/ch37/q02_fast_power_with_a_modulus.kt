// Q2. Fast Power with a Modulus (Toy Signature Check)
// Source: book/part-viii/37-math-and-number-drills.md
package ch37.q02_fast_power_with_a_modulus

fun modPow(base: Long, exponent: Long, mod: Long): Long {
    require(exponent >= 0 && mod in 1..3_037_000_499L) // so (mod - 1)^2 fits in a Long
    var result = 1L % mod
    var b = ((base % mod) + mod) % mod                  // make a negative base positive
    var e = exponent
    while (e > 0) {
        if (e and 1L == 1L) result = result * b % mod   // this bit is set: multiply it in
        b = b * b % mod                                 // square for the next bit
        e = e shr 1
    }
    return result
}
