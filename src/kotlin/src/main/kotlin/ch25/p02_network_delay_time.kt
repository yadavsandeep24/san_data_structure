// P2: Network delay time
// Source: solutions/ch25/README.md
package ch25.p02_network_delay_time

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
    var ans = 0
    for (i in 1..n) {
        if (dist[i] >= Int.MAX_VALUE / 4) return -1
        ans = maxOf(ans, dist[i])
    }
    return ans
}
