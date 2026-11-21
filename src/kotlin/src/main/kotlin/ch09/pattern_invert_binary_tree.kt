// Pattern: invert binary tree
// Source: book/part-iii/09-trees-basics.md
package ch09.pattern_invert_binary_tree

import dsa.common.TreeNode

fun invertTree(root: TreeNode?): TreeNode? {
    if (root == null) return null
    val tmp = root.left
    root.left = invertTree(root.right)
    root.right = invertTree(tmp)
    return root
}
