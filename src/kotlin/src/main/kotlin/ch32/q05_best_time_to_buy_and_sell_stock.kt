// Q5. Best Time to Buy and Sell Stock (One-Trade Profit)
// Source: book/part-viii/32-two-pointers-windows-intervals.md
package ch32.q05_best_time_to_buy_and_sell_stock

fun maxProfit(prices: IntArray): Int {
    var minSoFar = Int.MAX_VALUE
    var best = 0
    for (p in prices) {
        if (p < minSoFar) minSoFar = p
        else best = maxOf(best, p - minSoFar)
    }
    return best
}
