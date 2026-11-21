// P3: Flatten nested map keys
// Source: solutions/ch10/README.md
package ch10.p03_flatten_nested_map_keys

@Suppress("UNCHECKED_CAST")
fun flatten(node: Any?, prefix: String = ""): Map<String, Any?> {
    val out = LinkedHashMap<String, Any?>()
    fun walk(n: Any?, path: String) {
        when (n) {
            is Map<*, *> -> {
                if (n.isEmpty() && path.isNotEmpty()) out[path] = n
                for ((k, v) in n) {
                    val next = if (path.isEmpty()) "$k" else "$path.$k"
                    walk(v, next)
                }
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
