// Q4. Integer Square Root without Floating Point (Thumbnail Grid)
// Source: book/part-viii/37-math-and-number-drills.md

func isqrt(_ x: Int) -> Int {
    precondition(x >= 0)
    var lo = 0
    var hi = min(x, 3_037_000_499)                      // largest r whose square fits in Int64
    while lo < hi {
        let mid = lo + (hi - lo + 1) / 2                // round up so the loop always shrinks
        if mid <= x / mid { lo = mid } else { hi = mid - 1 }   // mid * mid <= x, without overflow
    }
    return lo
}
