// Pattern: two-sum with a map
// Source: book/part-iii/07-hash-tables.md
package ch07.pattern_two_sum_with_a_map

fun twoSum(nums: IntArray, target: Int): IntArray {
    val seen = HashMap<Int, Int>()
    for (i in nums.indices) {
        val need = target - nums[i]
        seen[need]?.let { return intArrayOf(it, i) }
        seen[nums[i]] = i
    }
    return intArrayOf()
}
