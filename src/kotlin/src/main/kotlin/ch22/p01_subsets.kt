// P1: Subsets
// Source: solutions/ch22/README.md
package ch22.p01_subsets

fun subsets(nums: IntArray): List<List<Int>> {
    val out = mutableListOf<List<Int>>()
    val path = mutableListOf<Int>()
    fun dfs(i: Int) {
        if (i == nums.size) {
            out += path.toList()
            return
        }
        dfs(i + 1)                 // skip
        path += nums[i]            // take
        dfs(i + 1)
        path.removeAt(path.lastIndex)
    }
    dfs(0)
    return out
}
