// P4. Task Scheduler (Priority Queue)
// Source: solutions/ch38/README.md
package ch38.p04_task_scheduler

data class Task(val id: String, val priority: Int, val seq: Long, val run: () -> Unit)

class TaskScheduler {
    private var seq = 0L
    private val pq = java.util.PriorityQueue<Task>(compareBy<Task> { -it.priority }.thenBy { it.seq })
    private val cancelled = HashSet<String>()
    fun schedule(id: String, priority: Int, run: () -> Unit) {
        pq.add(Task(id, priority, seq++, run))
    }
    fun cancel(id: String) { cancelled.add(id) }
    fun runNext(): Boolean {
        while (pq.isNotEmpty()) {
            val t = pq.poll()!!
            if (t.id in cancelled) { cancelled.remove(t.id); continue }
            t.run(); return true
        }
        return false
    }
}
