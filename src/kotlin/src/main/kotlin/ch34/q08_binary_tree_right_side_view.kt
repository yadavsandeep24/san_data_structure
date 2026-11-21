// Q8. Binary Tree Right Side View (What the Right Edge Shows)
// Source: book/part-viii/34-linked-lists-trees.md
package ch34.q08_binary_tree_right_side_view

import dsa.common.TreeNode

import ch34.shared_node_classes.*

fun rightSideView(root: TreeNode?): List<Int> {
    val out = mutableListOf<Int>()
    if (root == null) return out
    val q = ArrayDeque<TreeNode>()
    q.addLast(root)
    while (q.isNotEmpty()) {
        val size = q.size
        repeat(size) { i ->
            val n = q.removeFirst()
            if (i == size - 1) out += n.`val` // last node of this level
            n.left?.let { q.addLast(it) }
            n.right?.let { q.addLast(it) }
        }
    }
    return out
}
