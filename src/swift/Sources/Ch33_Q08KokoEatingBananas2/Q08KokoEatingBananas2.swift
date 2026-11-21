// Q8 — Koko eating bananas (Swift / Dart)
// Source: solutions/ch33/README.md

func minEatingSpeed(_ piles: [Int], _ h: Int) -> Int {
    var lo = 1, hi = piles.max() ?? 1
    while lo < hi {
        let k = lo + (hi - lo) / 2
        let hours = piles.reduce(0) { $0 + ($1 - 1) / k + 1 } // sum of ceil(p / k)
        if hours <= h { hi = k } else { lo = k + 1 }
    }
    return lo
}
