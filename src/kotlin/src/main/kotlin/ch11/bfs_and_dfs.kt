// BFS and DFS
// Source: book/part-iii/11-graphs-intro.md
package ch11.bfs_and_dfs

fun bfs(graph: Map<Int, List<Int>>, start: Int): List<Int> {
    val seen = hashSetOf(start)
    val q = ArrayDeque(listOf(start))
    val order = mutableListOf<Int>()
    while (q.isNotEmpty()) {
        val u = q.removeFirst()
        order += u
        for (v in graph[u].orEmpty()) {
            if (seen.add(v)) q.addLast(v)   // mark when enqueued
        }
    }
    return order
}

fun dfs(graph: Map<Int, List<Int>>, start: Int): List<Int> {
    val seen = HashSet<Int>()
    val order = mutableListOf<Int>()
    fun go(u: Int) {
        seen += u
        order += u
        for (v in graph[u].orEmpty()) if (v !in seen) go(v)
    }
    go(start)
    return order
}
