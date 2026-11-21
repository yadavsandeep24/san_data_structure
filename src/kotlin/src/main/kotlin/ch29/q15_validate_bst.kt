// Q15. Validate BST
// Source: book/part-viii/29-interview-questions-q11-q20.md
package ch29.q15_validate_bst

import dsa.common.TreeNode

fun isValidBST(root: TreeNode?): Boolean {
    fun go(n: TreeNode?, lo: Long, hi: Long): Boolean {
        if (n == null) return true
        val v = n.`val`.toLong()
        if (v <= lo || v >= hi) return false
        return go(n.left, lo, v) && go(n.right, v, hi)
    }
    return go(root, Long.MIN_VALUE, Long.MAX_VALUE)
}
