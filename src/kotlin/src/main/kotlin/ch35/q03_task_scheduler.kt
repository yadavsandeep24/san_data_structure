// Q3. Task Scheduler (Notification Cooldown Slots)
// Source: book/part-viii/35-heaps-tries-greedy.md
package ch35.q03_task_scheduler

fun leastInterval(tasks: CharArray, n: Int): Int {
    if (tasks.isEmpty()) return 0
    val freq = IntArray(26)
    for (t in tasks) freq[t - 'A']++
    val maxF = freq.max()
    val maxCount = freq.count { it == maxF }
    // (maxF - 1) full frames of width n + 1, plus a last row of the top tasks
    return maxOf(tasks.size, (maxF - 1) * (n + 1) + maxCount)
}
