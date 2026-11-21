// Q4. Find Minimum in Rotated Sorted Array (Oldest Slot in a Ring Buffer)
// Source: book/part-viii/33-stacks-binary-search.md
package ch33.q04_find_minimum_in_rotated_sorted_array

fun findMin(nums: IntArray): Int {
    var lo = 0
    var hi = nums.lastIndex
    while (lo < hi) {
        val mid = lo + (hi - lo) / 2
        if (nums[mid] > nums[hi]) lo = mid + 1 // minimum is right of mid
        else hi = mid                         // mid could be the minimum
    }
    return nums[lo]
}
