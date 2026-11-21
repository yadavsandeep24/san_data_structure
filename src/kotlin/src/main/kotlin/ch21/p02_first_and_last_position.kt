// P2: First and last position
// Source: solutions/ch21/README.md
package ch21.p02_first_and_last_position

fun searchRange(nums: IntArray, target: Int): IntArray {
    fun lower(): Int {
        var lo = 0
        var hi = nums.size
        while (lo < hi) {
            val mid = lo + (hi - lo) / 2
            if (nums[mid] < target) lo = mid + 1 else hi = mid
        }
        return lo
    }
    fun upper(): Int {
        var lo = 0
        var hi = nums.size
        while (lo < hi) {
            val mid = lo + (hi - lo) / 2
            if (nums[mid] <= target) lo = mid + 1 else hi = mid
        }
        return lo
    }
    val L = lower()
    if (L == nums.size || nums[L] != target) return intArrayOf(-1, -1)
    return intArrayOf(L, upper() - 1)
}
