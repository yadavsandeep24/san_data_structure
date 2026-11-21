// Q13. Binary Tree Maximum Path Sum
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md
package ch30.q13_binary_tree_maximum_path_sum

import dsa.common.TreeNode

fun maxPathSum(root: TreeNode?): Int {
    var best = Int.MIN_VALUE
    fun gain(n: TreeNode?): Int {
        if (n == null) return 0
        val l = maxOf(0, gain(n.left))
        val r = maxOf(0, gain(n.right))
        best = maxOf(best, n.`val` + l + r)
        return n.`val` + maxOf(l, r)
    }
    gain(root)
    return best
}
