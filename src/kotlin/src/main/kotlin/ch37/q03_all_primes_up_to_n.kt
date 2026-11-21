// Q3. All Primes up to n (Sieve)
// Source: book/part-viii/37-math-and-number-drills.md
package ch37.q03_all_primes_up_to_n

fun primesUpTo(n: Int): List<Int> {
    if (n < 2) return emptyList()
    val composite = BooleanArray(n + 1)
    var p = 2
    while (p.toLong() * p <= n) {                       // Long so p * p can't overflow near Int.MAX_VALUE
        if (!composite[p]) {
            var multiple = p * p                        // smaller multiples were crossed out by smaller primes
            while (multiple <= n) {
                composite[multiple] = true
                multiple += p
            }
        }
        p++
    }
    return (2..n).filter { !composite[it] }
}
