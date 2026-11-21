// Q5. Maximum Subarray (Best Trading Streak)
// Source: book/part-viii/31-arrays-hashing-matrix.md
package ch31.q05_maximum_subarray

fun maxSubArray(nums: IntArray): Int {
    var best = nums[0]
    var cur = nums[0]
    for (i in 1 until nums.size) {
        cur = maxOf(nums[i], cur + nums[i])
        best = maxOf(best, cur)
    }
    return best
}
