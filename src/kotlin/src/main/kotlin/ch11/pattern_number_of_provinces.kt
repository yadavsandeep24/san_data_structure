// Pattern: number of provinces (connected components)
// Source: book/part-iii/11-graphs-intro.md
package ch11.pattern_number_of_provinces

fun findCircleNum(isConnected: Array<IntArray>): Int {
    val n = isConnected.size
    val seen = BooleanArray(n)
    var provinces = 0
    fun dfs(u: Int) {
        seen[u] = true
        for (v in 0 until n) {
            if (isConnected[u][v] == 1 && !seen[v]) dfs(v)
        }
    }
    for (i in 0 until n) {
        if (!seen[i]) {
            provinces++
            dfs(i)
        }
    }
    return provinces
}
