// P3: Simplify absolute path
// Source: solutions/ch05/README.md
package ch05.p03_simplify_absolute_path

fun simplifyPath(path: String): String {
    val st = ArrayDeque<String>()
    for (part in path.split('/')) {
        when (part) {
            "", "." -> Unit
            ".." -> if (st.isNotEmpty()) st.removeLast()
            else -> st.addLast(part)
        }
    }
    return "/" + st.joinToString("/")
}
