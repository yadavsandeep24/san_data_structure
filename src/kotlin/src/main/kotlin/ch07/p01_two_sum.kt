// P1: Two Sum
// Source: solutions/ch07/README.md
package ch07.p01_two_sum

fun twoSum(nums: IntArray, target: Int): IntArray {
    val seen = HashMap<Int, Int>()
    for (i in nums.indices) {
        val need = target - nums[i]
        val j = seen[need]
        if (j != null) return intArrayOf(j, i)
        seen[nums[i]] = i
    }
    return intArrayOf()
}
