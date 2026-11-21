// Q12. Best Time to Buy and Sell Stock with Cooldown (Price Chart Cooldown Rule)
// Source: book/part-viii/36-graphs-dynamic-programming.md

func maxProfit(_ prices: [Int]) -> Int {
    var hold = Int.min / 2 // own a share
    var sold = 0           // sold today (cooldown tomorrow)
    var rest = 0           // no share, free to buy
    for p in prices {
        let prevHold = hold
        hold = max(hold, rest - p)
        rest = max(rest, sold)
        sold = prevHold + p
    }
    return max(sold, rest)
}
