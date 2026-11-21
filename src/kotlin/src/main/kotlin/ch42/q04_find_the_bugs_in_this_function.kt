// Q4. Find the Bugs in This Function (Recent Completed Envelopes)
// The buggy version from the question is kept as recentCompletedBuggy; recentCompleted is the fix.
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md
package ch42.q04_find_the_bugs_in_this_function

data class Envelope(val id: String, val status: String, val completedAt: Long?)

fun recentCompletedBuggy(all: List<Envelope>, n: Int): List<Envelope> {
    val done = all.filter { it.status == "Completed" }
    val sorted = done.sortedBy { it.completedAt }
    return sorted.subList(0, n)
}

fun recentCompleted(all: List<Envelope>, n: Int): List<Envelope> {
    require(n >= 0) { "n must be non-negative, was $n" }
    return all.asSequence()
        .filter { it.status.equals("completed", ignoreCase = true) && it.completedAt != null }
        .sortedByDescending { it.completedAt }
        .take(n)
        .toList()
}
