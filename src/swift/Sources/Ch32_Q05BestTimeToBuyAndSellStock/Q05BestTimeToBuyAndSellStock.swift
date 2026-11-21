// Q5. Best Time to Buy and Sell Stock (One-Trade Profit)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

func maxProfit(_ prices: [Int]) -> Int {
    var minSoFar = Int.max
    var best = 0
    for p in prices {
        if p < minSoFar { minSoFar = p } else { best = max(best, p - minSoFar) }
    }
    return best
}
