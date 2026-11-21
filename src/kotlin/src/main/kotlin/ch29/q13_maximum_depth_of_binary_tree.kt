// Q13. Maximum Depth of Binary Tree
// Source: book/part-viii/29-interview-questions-q11-q20.md
package ch29.q13_maximum_depth_of_binary_tree

class TreeNode(var `val`: Int, var left: TreeNode? = null, var right: TreeNode? = null)
fun maxDepth(root: TreeNode?): Int =
    if (root == null) 0 else 1 + maxOf(maxDepth(root.left), maxDepth(root.right))
