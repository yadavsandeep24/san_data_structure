// Q9. Longest Increasing Subsequence (Longest Rising Streak)
// Source: book/part-viii/36-graphs-dynamic-programming.md
package ch36.q09_longest_increasing_subsequence

fun lengthOfLIS(nums: IntArray): Int {
    val tails = IntArray(nums.size) // tails[k] = smallest tail of an increasing run of length k+1
    var size = 0
    for (x in nums) {
        var lo = 0
        var hi = size
        while (lo < hi) {
            val mid = (lo + hi) ushr 1
            if (tails[mid] < x) lo = mid + 1 else hi = mid
        }
        tails[lo] = x
        if (lo == size) size++
    }
    return size
}
