// Q6. Jump Game II (Fewest Deep-Link Hops)
// Source: book/part-viii/35-heaps-tries-greedy.md
package ch35.q06_jump_game_ii

fun jump(nums: IntArray): Int {
    var jumps = 0
    var curEnd = 0   // last index reachable with `jumps` jumps
    var farthest = 0 // last index reachable with one more jump
    for (i in 0 until nums.lastIndex) {
        farthest = maxOf(farthest, i + nums[i])
        if (i == curEnd) {
            jumps++
            curEnd = farthest
        }
    }
    return jumps
}
