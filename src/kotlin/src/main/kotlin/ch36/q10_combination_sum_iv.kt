// Q10. Combination Sum IV (Ordered Top-Up Sequences)
// Source: book/part-viii/36-graphs-dynamic-programming.md
package ch36.q10_combination_sum_iv

fun combinationSum4(nums: IntArray, target: Int): Long {
    val ways = LongArray(target + 1)
    ways[0] = 1
    for (t in 1..target) {
        for (x in nums) if (x <= t) ways[t] += ways[t - x] // x is the last step
    }
    return ways[target]
}
