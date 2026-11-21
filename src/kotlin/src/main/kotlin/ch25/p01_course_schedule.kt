// P1: Course schedule
// Source: solutions/ch25/README.md
package ch25.p01_course_schedule

fun canFinish(numCourses: Int, prerequisites: Array<IntArray>): Boolean {
    val g = Array(numCourses) { mutableListOf<Int>() }
    val indeg = IntArray(numCourses)
    for (p in prerequisites) {
        val a = p[0]
        val b = p[1]
        g[b].add(a)
        indeg[a]++
    }
    val q = ArrayDeque<Int>()
    for (i in 0 until numCourses) if (indeg[i] == 0) q.add(i)
    var seen = 0
    while (q.isNotEmpty()) {
        val u = q.removeFirst()
        seen++
        for (v in g[u]) if (--indeg[v] == 0) q.add(v)
    }
    return seen == numCourses
}
