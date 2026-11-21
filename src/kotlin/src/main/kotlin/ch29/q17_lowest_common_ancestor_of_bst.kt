// Q17. Lowest Common Ancestor of BST
// Source: book/part-viii/29-interview-questions-q11-q20.md
package ch29.q17_lowest_common_ancestor_of_bst

import dsa.common.TreeNode

fun lowestCommonAncestor(root: TreeNode?, p: TreeNode?, q: TreeNode?): TreeNode? {
    var cur = root
    val a = p!!.`val`; val b = q!!.`val`
    while (cur != null) {
        cur = when {
            a < cur.`val` && b < cur.`val` -> cur.left
            a > cur.`val` && b > cur.`val` -> cur.right
            else -> return cur
        }
    }
    return null
}
