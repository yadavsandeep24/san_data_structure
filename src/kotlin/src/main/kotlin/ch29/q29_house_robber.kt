// Q29. House Robber
// Source: book/part-viii/29-interview-questions-q21-q30.md
package ch29.q29_house_robber

fun rob(nums: IntArray): Int {
    var prev2 = 0; var prev1 = 0
    for (x in nums) {
        val cur = maxOf(prev1, prev2 + x)
        prev2 = prev1; prev1 = cur
    }
    return prev1
}
