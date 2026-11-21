// Q6. Balanced Binary Tree (Layout Depth Check)
// Source: book/part-viii/34-linked-lists-trees.md
package ch34.q06_balanced_binary_tree

import dsa.common.TreeNode

import ch34.shared_node_classes.*

fun isBalanced(root: TreeNode?): Boolean {
    fun height(node: TreeNode?): Int { // -1 means "already unbalanced"
        if (node == null) return 0
        val l = height(node.left)
        if (l == -1) return -1
        val r = height(node.right)
        if (r == -1 || kotlin.math.abs(l - r) > 1) return -1
        return 1 + maxOf(l, r)
    }
    return height(root) != -1
}
