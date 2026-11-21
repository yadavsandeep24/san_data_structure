// Q1. GCD and LCM (Reminder Schedules)
// Source: book/part-viii/37-math-and-number-drills.md
package ch37.q01_gcd_and_lcm

tailrec fun gcd(a: Long, b: Long): Long = if (b == 0L) a else gcd(b, a % b)

fun lcm(a: Long, b: Long): Long {
    require(a > 0 && b > 0)
    return Math.multiplyExact(a / gcd(a, b), b)        // divide first; throw if it still overflows
}
