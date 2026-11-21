// Q8. Koko Eating Bananas (Minimum Upload Rate)
// Source: book/part-viii/33-stacks-binary-search.md
package ch33.q08_koko_eating_bananas

fun minEatingSpeed(piles: IntArray, h: Int): Int {
    var lo = 1
    var hi = piles.max()
    while (lo < hi) {
        val k = lo + (hi - lo) / 2
        var hours = 0L
        for (p in piles) hours += (p - 1) / k + 1  // ceil(p / k), overflow-safe
        if (hours <= h) hi = k else lo = k + 1    // feasible: try slower
    }
    return lo
}
