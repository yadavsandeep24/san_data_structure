// Q7. Subtree of Another Tree (Find a Component Pattern)
// Source: book/part-viii/34-linked-lists-trees.md
package ch34.q07_subtree_of_another_tree

import dsa.common.TreeNode

import ch34.shared_node_classes.*

fun isSubtree(root: TreeNode?, subRoot: TreeNode?): Boolean {
    fun same(a: TreeNode?, b: TreeNode?): Boolean =
        if (a == null || b == null) a === b
        else a.`val` == b.`val` && same(a.left, b.left) && same(a.right, b.right)

    if (subRoot == null) return true
    if (root == null) return false
    return same(root, subRoot) || isSubtree(root.left, subRoot) || isSubtree(root.right, subRoot)
}
