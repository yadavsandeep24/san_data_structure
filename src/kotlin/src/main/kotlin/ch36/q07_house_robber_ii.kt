// Q7. House Robber II (Circular Carousel Ad Slots)
// Source: book/part-viii/36-graphs-dynamic-programming.md
package ch36.q07_house_robber_ii

fun rob(nums: IntArray): Int {
    if (nums.size == 1) return nums[0]
    fun robLine(from: Int, to: Int): Int {
        var prev = 0 // best up to i-2
        var best = 0 // best up to i-1
        for (i in from..to) {
            val take = prev + nums[i]
            prev = best
            best = maxOf(best, take)
        }
        return best
    }
    return maxOf(robLine(0, nums.size - 2), robLine(1, nums.size - 1))
}
