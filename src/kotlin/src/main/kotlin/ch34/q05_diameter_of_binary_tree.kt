// Q5. Diameter of Binary Tree (Longest Path in a View Tree)
// Source: book/part-viii/34-linked-lists-trees.md
package ch34.q05_diameter_of_binary_tree

import dsa.common.TreeNode

import ch34.shared_node_classes.*

fun diameterOfBinaryTree(root: TreeNode?): Int {
    var best = 0
    fun height(node: TreeNode?): Int { // nodes on the longest downward path
        if (node == null) return 0
        val l = height(node.left)
        val r = height(node.right)
        best = maxOf(best, l + r) // longest path bending at this node
        return 1 + maxOf(l, r)
    }
    height(root)
    return best
}
