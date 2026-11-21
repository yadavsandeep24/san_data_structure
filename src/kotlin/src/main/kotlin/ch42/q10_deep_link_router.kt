// Q10. Deep-Link Router (Open the Right Envelope Screen)
// Source: book/part-ix/42-document-signing-drill-bank-q08-q13.md
package ch42.q10_deep_link_router

class Router<T> {
    private class Node<T> {
        val kids = HashMap<String, Node<T>>()
        var param: Pair<String, Node<T>>? = null
        var wildcard: T? = null
        var value: T? = null
    }

    private val root = Node<T>()

    fun add(pattern: String, value: T) {
        var n = root
        for (seg in pattern.trim('/').split('/').filter { it.isNotEmpty() }) {
            when {
                seg == "*" -> { n.wildcard = value; return }
                seg.startsWith(":") -> {
                    val p = n.param ?: (seg.drop(1) to Node<T>()).also { n.param = it }
                    n = p.second
                }
                else -> n = n.kids.getOrPut(seg) { Node() }
            }
        }
        n.value = value
    }

    /** Static segments beat :params, which beat *. Backtracks if a static branch dead-ends. */
    fun match(path: String): Pair<T, Map<String, String>>? {
        val segs = path.substringBefore('?').trim('/').split('/').filter { it.isNotEmpty() }
        fun go(n: Node<T>, i: Int, params: Map<String, String>): Pair<T, Map<String, String>>? {
            if (i == segs.size) return n.value?.let { it to params } ?: n.wildcard?.let { it to params }
            n.kids[segs[i]]?.let { k -> go(k, i + 1, params)?.let { return it } }
            n.param?.let { (name, k) -> go(k, i + 1, params + (name to segs[i]))?.let { return it } }
            return n.wildcard?.let { it to params }
        }
        return go(root, 0, emptyMap())
    }
}
