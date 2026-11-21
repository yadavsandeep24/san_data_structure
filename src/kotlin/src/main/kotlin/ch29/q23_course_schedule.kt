// Q23. Course Schedule (Cycle Detect)
// Source: book/part-viii/29-interview-questions-q21-q30.md
package ch29.q23_course_schedule

fun canFinish(numCourses: Int, prerequisites: Array<IntArray>): Boolean {
    val adj = List(numCourses) { mutableListOf<Int>() }
    val indeg = IntArray(numCourses)
    for (e in prerequisites) { adj[e[1]].add(e[0]); indeg[e[0]]++ }
    val q = ArrayDeque<Int>()
    for (i in indeg.indices) if (indeg[i] == 0) q.add(i)
    var seen = 0
    while (q.isNotEmpty()) {
        val u = q.removeFirst(); seen++
        for (v in adj[u]) if (--indeg[v] == 0) q.add(v)
    }
    return seen == numCourses
}
