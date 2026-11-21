// Q19. Search Insert Position (Lower Bound)
// Source: book/part-viii/29-interview-questions-q11-q20.md
package ch29.q19_search_insert_position

fun searchInsert(nums: IntArray, target: Int): Int {
    var lo = 0; var hi = nums.size
    while (lo < hi) {
        val mid = (lo + hi) ushr 1
        if (nums[mid] < target) lo = mid + 1 else hi = mid
    }
    return lo
}
