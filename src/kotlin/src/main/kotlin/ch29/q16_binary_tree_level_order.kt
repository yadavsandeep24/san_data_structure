// Q16. Binary Tree Level Order
// Source: book/part-viii/29-interview-questions-q11-q20.md
package ch29.q16_binary_tree_level_order

import dsa.common.TreeNode

fun levelOrder(root: TreeNode?): List<List<Int>> {
    if (root == null) return emptyList()
    val q = ArrayDeque<TreeNode>()
    q.add(root)
    val out = mutableListOf<List<Int>>()
    while (q.isNotEmpty()) {
        val level = mutableListOf<Int>()
        repeat(q.size) {
            val n = q.removeFirst()
            level.add(n.`val`)
            n.left?.let(q::add)
            n.right?.let(q::add)
        }
        out.add(level)
    }
    return out
}
