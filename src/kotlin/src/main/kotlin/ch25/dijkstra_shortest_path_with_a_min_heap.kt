// Dijkstra — shortest path with a min-heap
// Source: book/part-vii/25-graphs-advanced.md
package ch25.dijkstra_shortest_path_with_a_min_heap

fun networkDelayTime(times: Array<IntArray>, n: Int, k: Int): Int {
    val g = Array(n + 1) { mutableListOf<Pair<Int, Int>>() }
    for (t in times) g[t[0]].add(t[1] to t[2])
    val dist = IntArray(n + 1) { Int.MAX_VALUE / 4 }
    dist[k] = 0
    val pq = java.util.PriorityQueue(compareBy<Pair<Int, Int>> { it.first })
    pq.add(0 to k)
    while (pq.isNotEmpty()) {
        val (d, u) = pq.poll()
        if (d > dist[u]) continue
        for ((v, w) in g[u]) {
            if (d + w < dist[v]) {
                dist[v] = d + w
                pq.add(dist[v] to v)
            }
        }
    }
    val ans = dist.drop(1).maxOrNull()!!
    return if (ans >= Int.MAX_VALUE / 4) -1 else ans
}
