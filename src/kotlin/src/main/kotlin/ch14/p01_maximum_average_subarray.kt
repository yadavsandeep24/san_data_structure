// P1: Maximum average subarray
// Source: solutions/ch14/README.md
package ch14.p01_maximum_average_subarray

fun findMaxAverage(nums: IntArray, k: Int): Double {
    var sum = 0L
    for (i in 0 until k) sum += nums[i]
    var best = sum
    for (r in k until nums.size) {
        sum += nums[r] - nums[r - k]
        if (sum > best) best = sum
    }
    return best.toDouble() / k
}
