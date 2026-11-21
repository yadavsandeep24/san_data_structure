// P3: Longest consecutive sequence
// Source: solutions/ch08/README.md
package ch08.p03_longest_consecutive_sequence

fun longestConsecutive(nums: IntArray): Int {
    val set = nums.toHashSet()
    var best = 0
    for (x in set) {
        if (x - 1 in set) continue
        var y = x
        var len = 1
        while (y + 1 in set) {
            y++
            len++
        }
        best = maxOf(best, len)
    }
    return best
}
