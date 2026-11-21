// Pattern: shortest path in unweighted graph
// Source: book/part-iii/11-graphs-intro.md
package ch11.pattern_shortest_path_in_unweighted_graph

fun shortestHops(g: Map<String, List<String>>, src: String, dst: String): Int? {
    if (src == dst) return 0
    val dist = hashMapOf(src to 0)
    val q = ArrayDeque(listOf(src))
    while (q.isNotEmpty()) {
        val u = q.removeFirst()
        for (v in g[u].orEmpty()) {
            if (v !in dist) {
                dist[v] = dist.getValue(u) + 1
                if (v == dst) return dist[v]
                q.addLast(v)
            }
        }
    }
    return null // unreachable
}
