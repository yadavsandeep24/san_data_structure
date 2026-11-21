// Q24. Shortest Path in Unweighted Graph
// Source: book/part-viii/29-interview-questions-q21-q30.md
package ch29.q24_shortest_path_in_unweighted_graph

fun shortestPath(g: Map<Int, List<Int>>, start: Int, end: Int): Int {
    if (start == end) return 0
    val seen = hashSetOf(start)
    val q = ArrayDeque(listOf(start))
    var dist = 0
    while (q.isNotEmpty()) {
        repeat(q.size) {
            val u = q.removeFirst()
            for (v in g[u].orEmpty()) {
                if (v == end) return dist + 1
                if (seen.add(v)) q.addLast(v)
            }
        }
        dist++
    }
    return -1
}
