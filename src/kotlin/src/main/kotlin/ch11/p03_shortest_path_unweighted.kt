// P3: Shortest path unweighted
// Source: solutions/ch11/README.md
package ch11.p03_shortest_path_unweighted

fun shortestPath(
    graph: Map<String, List<String>>,
    src: String,
    dst: String,
): Pair<Int, List<String>>? {
    if (src == dst) return 0 to listOf(src)
    val parent = HashMap<String, String?>()
    parent[src] = null
    val q = ArrayDeque<String>()
    q.addLast(src)
    while (q.isNotEmpty()) {
        val u = q.removeFirst()
        for (v in graph[u].orEmpty()) {
            if (v in parent) continue
            parent[v] = u
            if (v == dst) {
                val path = ArrayDeque<String>()
                var cur: String? = dst
                while (cur != null) {
                    path.addFirst(cur)
                    cur = parent[cur]
                }
                return (path.size - 1) to path.toList()
            }
            q.addLast(v)
        }
    }
    return null
}
