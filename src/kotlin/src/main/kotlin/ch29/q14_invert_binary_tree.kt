// Q14. Invert Binary Tree
// Source: book/part-viii/29-interview-questions-q11-q20.md
package ch29.q14_invert_binary_tree

import dsa.common.TreeNode

fun invertTree(root: TreeNode?): TreeNode? {
    if (root == null) return null
    val tmp = root.left
    root.left = invertTree(root.right)
    root.right = invertTree(tmp)
    return root
}
