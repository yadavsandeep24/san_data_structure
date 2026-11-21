// Q13. Coin Change II (Ways to Make Change at the Till)
// Source: book/part-viii/36-graphs-dynamic-programming.md
package ch36.q13_coin_change_ii

fun change(amount: Int, coins: IntArray): Int {
    val ways = IntArray(amount + 1)
    ways[0] = 1
    for (coin in coins) { // coins outer => combinations, not orderings
        for (a in coin..amount) ways[a] += ways[a - coin] // Int wraps silently on unused intermediates
    }
    return ways[amount]
}
