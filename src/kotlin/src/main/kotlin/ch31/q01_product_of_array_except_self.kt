// Q1. Product of Array Except Self (Basket Price Multipliers)
// Source: book/part-viii/31-arrays-hashing-matrix.md
package ch31.q01_product_of_array_except_self

fun productExceptSelf(nums: IntArray): IntArray {
    val out = IntArray(nums.size) { 1 }
    var prefix = 1
    for (i in nums.indices) {
        out[i] = prefix
        prefix *= nums[i]
    }
    var suffix = 1
    for (i in nums.indices.reversed()) {
        out[i] *= suffix
        suffix *= nums[i]
    }
    return out
}
