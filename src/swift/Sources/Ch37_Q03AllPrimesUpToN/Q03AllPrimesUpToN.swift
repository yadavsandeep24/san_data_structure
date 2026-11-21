// Q3. All Primes up to n (Sieve)
// Source: book/part-viii/37-math-and-number-drills.md

func primesUpTo(_ n: Int) -> [Int] {
    if n < 2 { return [] }
    var composite = [Bool](repeating: false, count: n + 1)
    var p = 2
    while p * p <= n {                                  // Int is 64-bit, so p * p fits
        if !composite[p] {
            for multiple in stride(from: p * p, through: n, by: p) { composite[multiple] = true }
        }
        p += 1
    }
    return (2...n).filter { !composite[$0] }
}
