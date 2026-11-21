// Topological sort — Kahn’s algorithm
// Source: book/part-vii/25-graphs-advanced.md
package ch25.topological_sort_kahn_s_algorithm

fun topoSort(n: Int, edges: List<Pair<Int, Int>>): List<Int>? {
    val g = Array(n) { mutableListOf<Int>() }
    val indeg = IntArray(n)
    for ((u, v) in edges) {
        g[u].add(v)
        indeg[v]++
    }
    val q = ArrayDeque<Int>()
    for (i in 0 until n) if (indeg[i] == 0) q.add(i)
    val order = mutableListOf<Int>()
    while (q.isNotEmpty()) {
        val u = q.removeFirst()
        order.add(u)
        for (v in g[u]) {
            if (--indeg[v] == 0) q.add(v)
        }
    }
    return if (order.size == n) order else null
}
