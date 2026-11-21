// Pattern: longest consecutive sequence
// Source: book/part-iii/08-sets.md
package ch08.pattern_longest_consecutive_sequence

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
