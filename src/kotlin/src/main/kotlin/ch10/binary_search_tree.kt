// Binary Search Tree (BST)
// Source: book/part-iii/10-trees-practical.md
package ch10.binary_search_tree

import dsa.common.TreeNode

fun search(root: TreeNode?, key: Int): TreeNode? {
    var cur = root
    while (cur != null) {
        when {
            key == cur.value -> return cur
            key < cur.value -> cur = cur.left
            else -> cur = cur.right
        }
    }
    return null
}

fun insert(root: TreeNode?, key: Int): TreeNode {
    if (root == null) return TreeNode(key)
    if (key < root.value) root.left = insert(root.left, key)
    else if (key > root.value) root.right = insert(root.right, key)
    // equal: ignore or define multiset policy
    return root
}
