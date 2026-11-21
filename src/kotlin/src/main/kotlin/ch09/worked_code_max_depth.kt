// Worked code: max depth
// Source: book/part-iii/09-trees-basics.md
package ch09.worked_code_max_depth

import dsa.common.TreeNode

fun maxDepth(root: TreeNode?): Int {
    if (root == null) return 0
    return 1 + maxOf(maxDepth(root.left), maxDepth(root.right))
}
