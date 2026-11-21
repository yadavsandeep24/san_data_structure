// Q9. Count Good Nodes in Binary Tree (Record-High Checkpoints)
// Source: book/part-viii/34-linked-lists-trees.md
package ch34.q09_count_good_nodes_in_binary_tree

import dsa.common.TreeNode

import ch34.shared_node_classes.*

fun goodNodes(root: TreeNode?): Int {
    fun dfs(node: TreeNode?, maxSoFar: Int): Int {
        if (node == null) return 0
        val good = if (node.`val` >= maxSoFar) 1 else 0
        val next = maxOf(maxSoFar, node.`val`)
        return good + dfs(node.left, next) + dfs(node.right, next)
    }
    return dfs(root, Int.MIN_VALUE)
}
