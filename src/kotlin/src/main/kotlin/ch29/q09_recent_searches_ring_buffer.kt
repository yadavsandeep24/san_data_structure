// Q9. Recent Searches Ring Buffer
// Source: book/part-viii/29-interview-questions-q01-q10.md
package ch29.q09_recent_searches_ring_buffer

class RecentSearches(private val k: Int) {
    private val q = ArrayDeque<String>()
    private val seen = HashSet<String>()
    fun add(term: String) {
        if (!seen.add(term)) q.remove(term) // bump existing to newest
        q.addLast(term)
        while (q.size > k) seen.remove(q.removeFirst())
    }
    fun list(): List<String> = q.toList().asReversed()
}
