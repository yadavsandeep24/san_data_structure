// Q5. Subarray Sum Equals K
// Source: book/part-viii/29-interview-questions-q01-q10.md
package ch29.q05_subarray_sum_equals_k

fun subarraySum(nums: IntArray, k: Int): Int {
    val freq = HashMap<Int, Int>()
    freq[0] = 1
    var sum = 0
    var ans = 0
    for (x in nums) {
        sum += x
        ans += freq[sum - k] ?: 0
        freq[sum] = (freq[sum] ?: 0) + 1
    }
    return ans
}
