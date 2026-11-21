// Q11. Construct Binary Tree from Preorder and Inorder Traversal (Rebuild a Tree from Two Dumps)
// Source: book/part-viii/34-linked-lists-trees.md
package ch34.q11_construct_binary_tree_from_preorder_and_inor

import dsa.common.TreeNode

import ch34.shared_node_classes.*

fun buildTree(preorder: IntArray, inorder: IntArray): TreeNode? {
    val inIndex = HashMap<Int, Int>()
    inorder.forEachIndexed { i, v -> inIndex[v] = i }
    var pre = 0 // next root in preorder
    fun build(lo: Int, hi: Int): TreeNode? { // inorder window [lo, hi]
        if (lo > hi) return null
        val node = TreeNode(preorder[pre++])
        val mid = inIndex.getValue(node.`val`)
        node.left = build(lo, mid - 1)
        node.right = build(mid + 1, hi)
        return node
    }
    return build(0, inorder.lastIndex)
}
