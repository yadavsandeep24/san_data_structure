// Q9. Range Sum Query: Immutable (Statement Range Totals)
// Source: book/part-viii/31-arrays-hashing-matrix.md
package ch31.q09_range_sum_query_immutable

class NumArray(nums: IntArray) {
    private val prefix = LongArray(nums.size + 1)

    init {
        for (i in nums.indices) prefix[i + 1] = prefix[i] + nums[i]
    }

    fun sumRange(left: Int, right: Int): Long = prefix[right + 1] - prefix[left]
}
