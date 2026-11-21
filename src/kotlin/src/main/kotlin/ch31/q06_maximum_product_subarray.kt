// Q6. Maximum Product Subarray (Compounded Multiplier Streak)
// Source: book/part-viii/31-arrays-hashing-matrix.md
package ch31.q06_maximum_product_subarray

fun maxProduct(nums: IntArray): Int {
    var hi = nums[0]
    var lo = nums[0]
    var best = nums[0]
    for (i in 1 until nums.size) {
        val x = nums[i]
        val a = hi * x
        val b = lo * x
        hi = maxOf(x, a, b)
        lo = minOf(x, a, b)
        best = maxOf(best, hi)
    }
    return best
}
