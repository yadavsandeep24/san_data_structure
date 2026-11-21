// Q20. Find Peak Element
// Source: book/part-viii/29-interview-questions-q11-q20.md
package ch29.q20_find_peak_element

fun findPeakElement(nums: IntArray): Int {
    var lo = 0; var hi = nums.lastIndex
    while (lo < hi) {
        val mid = (lo + hi) ushr 1
        if (nums[mid] < nums[mid + 1]) lo = mid + 1 else hi = mid
    }
    return lo
}
