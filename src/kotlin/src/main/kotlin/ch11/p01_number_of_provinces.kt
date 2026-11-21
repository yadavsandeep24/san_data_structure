// P1: Number of provinces
// Source: solutions/ch11/README.md
package ch11.p01_number_of_provinces

fun findCircleNum(isConnected: Array<IntArray>): Int {
    val n = isConnected.size
    val seen = BooleanArray(n)
    var count = 0
    fun dfs(u: Int) {
        seen[u] = true
        for (v in 0 until n) {
            if (isConnected[u][v] == 1 && !seen[v]) dfs(v)
        }
    }
    for (i in 0 until n) {
        if (!seen[i]) {
            count++
            dfs(i)
        }
    }
    return count
}
