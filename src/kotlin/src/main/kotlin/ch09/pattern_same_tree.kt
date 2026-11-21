// Pattern: same tree
// Source: book/part-iii/09-trees-basics.md
package ch09.pattern_same_tree

import dsa.common.TreeNode

fun isSameTree(p: TreeNode?, q: TreeNode?): Boolean {
    if (p == null && q == null) return true
    if (p == null || q == null) return false
    if (p.value != q.value) return false
    return isSameTree(p.left, q.left) && isSameTree(p.right, q.right)
}
