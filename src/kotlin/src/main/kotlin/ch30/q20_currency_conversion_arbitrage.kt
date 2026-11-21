// Q20. Currency Conversion Arbitrage (Bellman-Ford)
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md
package ch30.q20_currency_conversion_arbitrage

fun hasArbitrage(pairs: List<Triple<String, String, Double>>): Boolean {
    val nodes = linkedSetOf<String>()
    for ((a, b, _) in pairs) { nodes += a; nodes += b }
    val idx = nodes.withIndex().associate { it.value to it.index }
    val n = nodes.size
    val edges = pairs.map { (a, b, rate) ->
        Triple(idx[a]!!, idx[b]!!, -kotlin.math.ln(rate))
    }
    val dist = DoubleArray(n) { 0.0 } // 0 allows detecting cycle reachable from any component
    repeat(n - 1) {
        for ((u, v, w) in edges) if (dist[v] > dist[u] + w) dist[v] = dist[u] + w
    }
    for ((u, v, w) in edges) if (dist[v] > dist[u] + w + 1e-12) return true
    return false
}
