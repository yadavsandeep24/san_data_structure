// JSON as a tree
// Source: book/part-iii/10-trees-practical.md
package ch10.json_as_a_tree

fun flatten(node: Any?, prefix: String = ""): Map<String, Any?> {
    val out = LinkedHashMap<String, Any?>()
    fun walk(n: Any?, path: String) {
        when (n) {
            is Map<*, *> -> {
                if (n.isEmpty() && path.isNotEmpty()) out[path] = n
                for ((k, v) in n) walk(v, if (path.isEmpty()) "$k" else "$path.$k")
            }
            is List<*> -> {
                if (n.isEmpty() && path.isNotEmpty()) out[path] = n
                n.forEachIndexed { i, v -> walk(v, "$path[$i]") }
            }
            else -> out[path] = n
        }
    }
    walk(node, prefix)
    return out
}
