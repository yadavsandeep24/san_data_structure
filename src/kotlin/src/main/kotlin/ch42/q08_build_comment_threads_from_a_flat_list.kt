// Q8. Build Comment Threads from a Flat List (Document Comments)
// Source: book/part-ix/42-document-signing-drill-bank-q08-q13.md
package ch42.q08_build_comment_threads_from_a_flat_list

data class Comment(val id: String, val parentId: String?, val at: Long, val text: String)
data class Thread(val comment: Comment, val replies: List<Thread>)

/** Roots newest first, replies oldest first. Orphans (parent missing) become roots. */
fun buildThreads(all: List<Comment>): List<Thread> {
    val byId = all.associateBy { it.id }
    val children = all
        .filter { it.parentId != null && it.parentId in byId && it.parentId != it.id }
        .groupBy { it.parentId!! }
    fun build(c: Comment, seen: MutableSet<String>): Thread {
        seen += c.id
        val kids = children[c.id].orEmpty().filter { it.id !in seen }.sortedBy { it.at }
        return Thread(c, kids.map { build(it, seen) })
    }
    val roots = all
        .filter { it.parentId == null || it.parentId !in byId || it.parentId == it.id }
        .sortedByDescending { it.at }
    val seen = mutableSetOf<String>()
    return roots.map { build(it, seen) }
}

fun Thread.count(): Int = 1 + replies.sumOf { it.count() }
