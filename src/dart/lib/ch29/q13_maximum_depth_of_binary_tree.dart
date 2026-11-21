// Q13. Maximum Depth of Binary Tree
// Source: book/part-viii/29-interview-questions-q11-q20.md

class TreeNode {
  int val; TreeNode? left, right;
  TreeNode(this.val, [this.left, this.right]);
}
int maxDepth(TreeNode? root) {
  if (root == null) return 0;
  final l = maxDepth(root.left), r = maxDepth(root.right);
  return 1 + (l > r ? l : r);
}
