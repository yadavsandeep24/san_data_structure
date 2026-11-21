// Q13. Coin Change II (Ways to Make Change at the Till)
// Source: book/part-viii/36-graphs-dynamic-programming.md

func change(_ amount: Int, _ coins: [Int]) -> Int {
    var ways = [Int](repeating: 0, count: amount + 1)
    ways[0] = 1
    for coin in coins where coin <= amount { // coins outer => combinations, not orderings
        for a in coin...amount { ways[a] &+= ways[a - coin] } // &+= wraps: unused intermediates may overflow
    }
    return ways[amount]
}
