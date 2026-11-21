// Q14. Target Sum (Signed Ledger Adjustments)
// Source: book/part-viii/36-graphs-dynamic-programming.md
package ch36.q14_target_sum

import kotlin.math.abs

fun findTargetSumWays(nums: IntArray, target: Int): Int {
    val total = nums.sum()
    if (abs(target) > total || (total + target) % 2 != 0) return 0
    val want = (total + target) / 2 // sum of the '+' group
    val ways = IntArray(want + 1)
    ways[0] = 1
    for (x in nums) {
        for (s in want downTo x) ways[s] += ways[s - x] // 0/1 knapsack, backwards
    }
    return ways[want]
}
