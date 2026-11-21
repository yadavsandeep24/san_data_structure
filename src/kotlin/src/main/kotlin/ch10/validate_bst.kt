// Validate BST
// Source: book/part-iii/10-trees-practical.md
package ch10.validate_bst

import dsa.common.TreeNode

fun isValidBST(root: TreeNode?): Boolean {
    fun go(n: TreeNode?, lo: Int?, hi: Int?): Boolean {
        if (n == null) return true
        if (lo != null && n.value <= lo) return false
        if (hi != null && n.value >= hi) return false
        return go(n.left, lo, n.value) && go(n.right, n.value, hi)
    }
    return go(root, null, null)
}
