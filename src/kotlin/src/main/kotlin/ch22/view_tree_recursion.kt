// View-tree recursion (mobile-shaped)
// Source: book/part-vi/22-recursion-backtracking.md
package ch22.view_tree_recursion

data class ViewNode(val id: String, val children: List<ViewNode> = emptyList())

fun countLeaves(node: ViewNode): Int {
    if (node.children.isEmpty()) return 1
    return node.children.sumOf { countLeaves(it) }
}

fun findById(node: ViewNode, target: String): ViewNode? {
    if (node.id == target) return node
    for (c in node.children) {
        findById(c, target)?.let { return it }
    }
    return null
}
