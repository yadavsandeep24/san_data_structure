// P1: Validate BST
// Source: solutions/ch10/README.md
package ch10.p01_validate_bst

import dsa.common.TreeNode

fun isValidBST(root: TreeNode?): Boolean {
    fun go(n: TreeNode?, lo: Long, hi: Long): Boolean {
        if (n == null) return true
        val v = n.value.toLong()
        if (v <= lo || v >= hi) return false
        return go(n.left, lo, v) && go(n.right, v, hi)
    }
    return go(root, Long.MIN_VALUE, Long.MAX_VALUE)
}
