// Q10. First Missing Positive (Next Free Ticket Number)
// Source: book/part-viii/31-arrays-hashing-matrix.md
package ch31.q10_first_missing_positive

fun firstMissingPositive(nums: IntArray): Int {
    val n = nums.size
    for (i in 0 until n) {
        while (nums[i] in 1..n && nums[nums[i] - 1] != nums[i]) {
            val j = nums[i] - 1
            nums[i] = nums[j].also { nums[j] = nums[i] }
        }
    }
    for (i in 0 until n) if (nums[i] != i + 1) return i + 1
    return n + 1
}
