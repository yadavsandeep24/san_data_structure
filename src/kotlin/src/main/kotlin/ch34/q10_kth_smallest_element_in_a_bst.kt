// Q10. Kth Smallest Element in a BST (Kth Cheapest in a Price Index)
// Source: book/part-viii/34-linked-lists-trees.md
package ch34.q10_kth_smallest_element_in_a_bst

import dsa.common.TreeNode

import ch34.shared_node_classes.*

fun kthSmallest(root: TreeNode?, k: Int): Int {
    val stack = ArrayDeque<TreeNode>()
    var cur = root
    var count = 0
    while (cur != null || stack.isNotEmpty()) {
        while (cur != null) { // walk left as far as possible
            stack.addLast(cur)
            cur = cur.left
        }
        val node = stack.removeLast()
        if (++count == k) return node.`val` // in-order visits values ascending
        cur = node.right
    }
    throw IllegalArgumentException("k > number of nodes")
}
