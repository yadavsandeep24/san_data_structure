// Binary search — the version that does not lie
// Source: book/part-vi/21-searching-sorting.md
package ch21.binary_search_the_version_that_does_not_lie

fun searchInsert(nums: IntArray, target: Int): Int {
    var lo = 0
    var hi = nums.size
    while (lo < hi) {
        val mid = lo + (hi - lo) / 2
        if (nums[mid] < target) lo = mid + 1 else hi = mid
    }
    return lo
}
