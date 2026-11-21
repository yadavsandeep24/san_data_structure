// Shared node classes
// Source: book/part-viii/34-linked-lists-trees.md
package ch34.shared_node_classes

class ListNode(var `val`: Int, var next: ListNode? = null)

class TreeNode(var `val`: Int) {
    var left: TreeNode? = null
    var right: TreeNode? = null
}
