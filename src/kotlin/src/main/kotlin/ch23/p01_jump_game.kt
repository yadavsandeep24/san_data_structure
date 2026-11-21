// P1: Jump game
// Source: solutions/ch23/README.md
package ch23.p01_jump_game

fun canJump(nums: IntArray): Boolean {
    var farthest = 0
    for (i in nums.indices) {
        if (i > farthest) return false
        farthest = maxOf(farthest, i + nums[i])
        if (farthest >= nums.lastIndex) return true
    }
    return true
}
