// Q1. Two Sum (Cart SKU Pair)
// Source: book/part-viii/29-interview-questions-q01-q10.md
package ch29.q01_two_sum

fun twoSum(nums: IntArray, target: Int): IntArray {
    val seen = HashMap<Int, Int>()
    for (i in nums.indices) {
        val j = seen[target - nums[i]]
        if (j != null) return intArrayOf(j, i)
        seen[nums[i]] = i
    }
    return intArrayOf()
}
