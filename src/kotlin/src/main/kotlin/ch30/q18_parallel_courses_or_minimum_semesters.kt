// Q18. Parallel Courses or Minimum Semesters
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md
package ch30.q18_parallel_courses_or_minimum_semesters

fun minimumSemesters(n: Int, relations: Array<IntArray>): Int {
    val g = Array(n + 1) { mutableListOf<Int>() }
    val indeg = IntArray(n + 1)
    for (e in relations) {
        g[e[0]].add(e[1])
        indeg[e[1]]++
    }
    val q = ArrayDeque<Int>()
    for (i in 1..n) if (indeg[i] == 0) q.add(i)
    var sem = 0
    var taken = 0
    while (q.isNotEmpty()) {
        sem++
        repeat(q.size) {
            val u = q.removeFirst()
            taken++
            for (v in g[u]) if (--indeg[v] == 0) q.add(v)
        }
    }
    return if (taken == n) sem else -1
}
