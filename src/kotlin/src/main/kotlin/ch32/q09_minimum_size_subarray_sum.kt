// Q9. Minimum Size Subarray Sum (Shortest Run to Reach a Spend Goal)
// Source: book/part-viii/32-two-pointers-windows-intervals.md
package ch32.q09_minimum_size_subarray_sum

fun minSubArrayLen(target: Int, nums: IntArray): Int {
    var left = 0
    var sum = 0L
    var best = Int.MAX_VALUE
    for (right in nums.indices) {
        sum += nums[right]
        while (sum >= target) {
            best = minOf(best, right - left + 1)
            sum -= nums[left++]
        }
    }
    return if (best == Int.MAX_VALUE) 0 else best
}
