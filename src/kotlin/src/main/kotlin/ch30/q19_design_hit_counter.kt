// Q19. Design Hit Counter (Rate Limit Window)
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md
package ch30.q19_design_hit_counter

class HitCounter {
    private val q = ArrayDeque<Int>()
    fun hit(timestamp: Int) { q.add(timestamp) }
    fun getHits(timestamp: Int): Int {
        while (q.isNotEmpty() && q.first() <= timestamp - 300) q.removeFirst()
        return q.size
    }
}
