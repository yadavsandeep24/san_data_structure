// P2: Invert binary tree
// Source: solutions/ch09/README.md
package ch09.p02_invert_binary_tree

import dsa.common.TreeNode

fun invertTree(root: TreeNode?): TreeNode? {
    if (root == null) return null
    val tmp = root.left
    root.left = invertTree(root.right)
    root.right = invertTree(tmp)
    return root
}
