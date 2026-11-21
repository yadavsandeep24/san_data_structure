// Traversals
// Source: book/part-iii/09-trees-basics.md
package ch09.traversals

import dsa.common.TreeNode

fun preorder(n: TreeNode?, visit: (Int) -> Unit) {
    if (n == null) return
    visit(n.value)
    preorder(n.left, visit)
    preorder(n.right, visit)
}

fun inorder(n: TreeNode?, visit: (Int) -> Unit) {
    if (n == null) return
    inorder(n.left, visit)
    visit(n.value)
    inorder(n.right, visit)
}

fun postorder(n: TreeNode?, visit: (Int) -> Unit) {
    if (n == null) return
    postorder(n.left, visit)
    postorder(n.right, visit)
    visit(n.value)
}

fun levelOrder(root: TreeNode?): List<List<Int>> {
    if (root == null) return emptyList()
    val res = mutableListOf<List<Int>>()
    val q = ArrayDeque<TreeNode>()
    q.addLast(root)
    while (q.isNotEmpty()) {
        val level = mutableListOf<Int>()
        repeat(q.size) {
            val node = q.removeFirst()
            level += node.value
            node.left?.let { q.addLast(it) }
            node.right?.let { q.addLast(it) }
        }
        res += level
    }
    return res
}
