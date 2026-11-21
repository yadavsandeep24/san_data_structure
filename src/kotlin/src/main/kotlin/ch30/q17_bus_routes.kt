// Q17. Bus Routes (Hard BFS)
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md
package ch30.q17_bus_routes

fun numBusesToDestination(routes: Array<IntArray>, source: Int, target: Int): Int {
    if (source == target) return 0
    val stopToBus = HashMap<Int, MutableList<Int>>()
    for (b in routes.indices) for (s in routes[b])
        stopToBus.getOrPut(s) { mutableListOf() }.add(b)
    val q = ArrayDeque<Int>()
    val seenBus = BooleanArray(routes.size)
    val seenStop = HashSet<Int>()
    q.add(source)
    seenStop.add(source)
    var buses = 0
    while (q.isNotEmpty()) {
        buses++
        repeat(q.size) {
            val stop = q.removeFirst()
            for (b in stopToBus[stop] ?: emptyList()) {
                if (seenBus[b]) continue
                seenBus[b] = true
                for (ns in routes[b]) {
                    if (ns == target) return buses
                    if (seenStop.add(ns)) q.add(ns)
                }
            }
        }
    }
    return -1
}
