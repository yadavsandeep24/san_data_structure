// Q12. Best Time to Buy and Sell Stock with Cooldown (Price Chart Cooldown Rule)
// Source: book/part-viii/36-graphs-dynamic-programming.md
package ch36.q12_best_time_to_buy_and_sell_stock_with_cooldow

fun maxProfit(prices: IntArray): Int {
    var hold = Int.MIN_VALUE / 2 // own a share
    var sold = 0                 // sold today (cooldown tomorrow)
    var rest = 0                 // no share, free to buy
    for (p in prices) {
        val prevHold = hold
        hold = maxOf(hold, rest - p)
        rest = maxOf(rest, sold)
        sold = prevHold + p
    }
    return maxOf(sold, rest)
}
