// Q6. Course Schedule II (Return Order)
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md
package ch30.q06_course_schedule_ii

fun findOrder(numCourses: Int, prerequisites: Array<IntArray>): IntArray {
    val g = Array(numCourses) { mutableListOf<Int>() }
    val indeg = IntArray(numCourses)
    for (e in prerequisites) {
        g[e[1]].add(e[0])
        indeg[e[0]]++
    }
    val q = ArrayDeque<Int>()
    for (i in 0 until numCourses) if (indeg[i] == 0) q.add(i)
    val order = IntArray(numCourses)
    var k = 0
    while (q.isNotEmpty()) {
        val u = q.removeFirst()
        order[k++] = u
        for (v in g[u]) if (--indeg[v] == 0) q.add(v)
    }
    return if (k == numCourses) order else intArrayOf()
}
