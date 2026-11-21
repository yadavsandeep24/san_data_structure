// Worked examples
// Source: book/part-v/20-decision-guide.md
package ch20.worked_examples

class Cart {
    private val order = mutableListOf<String>()           // sku order
    private val qty = HashMap<String, Int>()              // sku → count

    fun add(sku: String) {
        val n = qty[sku] ?: 0
        if (n == 0) order.add(sku)
        qty[sku] = n + 1
    }

    fun contains(sku: String) = qty.containsKey(sku)      // O(1)
    fun lines(): List<Pair<String, Int>> = order.map { it to qty.getValue(it) }
}

class RecentSearches(private val k: Int) {
    private val q = mutableListOf<String>()
    private var head = 0
    private val seen = HashSet<String>()

    fun add(term: String) {
        if (term in seen) {
            val i = q.subList(head, q.size).indexOf(term)
            if (i >= 0) q.removeAt(head + i)
        } else {
            seen += term
        }
        q += term
        while (q.size - head > k) {
            seen -= q[head++]
        }
    }

    fun list(): List<String> = q.subList(head, q.size).reversed()
}
