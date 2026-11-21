// Q21. Number of Provinces (Connected Components)
// Source: book/part-viii/29-interview-questions-q21-q30.md
package ch29.q21_number_of_provinces

fun findCircleNum(isConnected: Array<IntArray>): Int {
    val n = isConnected.size
    val seen = BooleanArray(n)
    fun dfs(i: Int) {
        seen[i] = true
        for (j in 0 until n) if (isConnected[i][j] == 1 && !seen[j]) dfs(j)
    }
    var provinces = 0
    for (i in 0 until n) if (!seen[i]) { provinces++; dfs(i) }
    return provinces
}
