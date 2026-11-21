// Q7. Alien Dictionary (Harder Graph Variant)
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md
package ch30.q07_alien_dictionary

fun alienOrder(words: Array<String>): String {
    val adj = HashMap<Char, MutableSet<Char>>()
    val indeg = HashMap<Char, Int>()
    for (w in words) for (c in w) {
        adj.putIfAbsent(c, hashSetOf())
        indeg.putIfAbsent(c, 0)
    }
    for (i in 0 until words.lastIndex) {
        val a = words[i]
        val b = words[i + 1]
        if (a.length > b.length && a.startsWith(b)) return ""
        val n = minOf(a.length, b.length)
        for (j in 0 until n) {
            if (a[j] != b[j]) {
                if (adj[a[j]]!!.add(b[j])) indeg[b[j]] = indeg[b[j]]!! + 1
                break
            }
        }
    }
    val q = ArrayDeque<Char>()
    for ((c, d) in indeg) if (d == 0) q.add(c)
    val sb = StringBuilder()
    while (q.isNotEmpty()) {
        val u = q.removeFirst()
        sb.append(u)
        for (v in adj[u]!!) {
            indeg[v] = indeg[v]!! - 1
            if (indeg[v] == 0) q.add(v)
        }
    }
    return if (sb.length == indeg.size) sb.toString() else ""
}
