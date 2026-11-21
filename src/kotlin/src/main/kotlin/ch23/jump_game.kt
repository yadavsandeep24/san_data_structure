// Jump game (mobile-relevant framing)
// Source: book/part-vi/23-greedy-thinking.md
package ch23.jump_game

fun canJump(nums: IntArray): Boolean {
    var farthest = 0
    for (i in nums.indices) {
        if (i > farthest) return false
        farthest = maxOf(farthest, i + nums[i])
        if (farthest >= nums.lastIndex) return true
    }
    return true
}
