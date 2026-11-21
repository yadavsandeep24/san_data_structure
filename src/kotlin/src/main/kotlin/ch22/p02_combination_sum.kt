// P2: Combination sum
// Source: solutions/ch22/README.md
package ch22.p02_combination_sum

fun combinationSum(candidates: IntArray, target: Int): List<List<Int>> {
    candidates.sort()
    val out = mutableListOf<List<Int>>()
    val path = mutableListOf<Int>()
    fun dfs(start: Int, remain: Int) {
        if (remain == 0) {
            out += path.toList()
            return
        }
        for (j in start until candidates.size) {
            val c = candidates[j]
            if (c > remain) break
            path += c
            dfs(j, remain - c)
            path.removeAt(path.lastIndex)
        }
    }
    dfs(0, target)
    return out
}
