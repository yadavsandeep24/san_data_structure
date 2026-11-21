// Q18. Binary Search
// Source: book/part-viii/29-interview-questions-q11-q20.md
package ch29.q18_binary_search

fun search(nums: IntArray, target: Int): Int {
    var lo = 0; var hi = nums.lastIndex
    while (lo <= hi) {
        val mid = (lo + hi) ushr 1
        when {
            nums[mid] == target -> return mid
            nums[mid] < target -> lo = mid + 1
            else -> hi = mid - 1
        }
    }
    return -1
}
