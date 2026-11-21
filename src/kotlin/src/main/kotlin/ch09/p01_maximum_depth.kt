// P1: Maximum depth
// Source: solutions/ch09/README.md
package ch09.p01_maximum_depth

class TreeNode(var value: Int) {
    var left: TreeNode? = null
    var right: TreeNode? = null
}

fun maxDepth(root: TreeNode?): Int {
    if (root == null) return 0
    return 1 + maxOf(maxDepth(root.left), maxDepth(root.right))
}
