// P1: Search insert position
// Source: solutions/ch21/README.md
package ch21.p01_search_insert_position

fun searchInsert(nums: IntArray, target: Int): Int {
    var lo = 0
    var hi = nums.size
    while (lo < hi) {
        val mid = lo + (hi - lo) / 2
        if (nums[mid] < target) lo = mid + 1 else hi = mid
    }
    return lo
}
