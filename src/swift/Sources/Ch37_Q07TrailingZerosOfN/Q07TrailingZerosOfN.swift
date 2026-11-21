// Q7. Trailing Zeros of n! (Big Number Sanity Check)
// Source: book/part-viii/37-math-and-number-drills.md

func trailingZerosOfFactorial(_ n: Int) -> Int {
    var count = 0
    var power = 5
    while power <= n {
        count += n / power                              // multiples of 5, then extra 5s from 25, 125, ...
        if power > Int.max / 5 { break }                // next power would trap on overflow
        power *= 5
    }
    return count
}
