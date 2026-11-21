// P1: Maximum depth
// Source: solutions/ch09/README.md
import 'dart:math';

class TreeNode {
  TreeNode(this.value, [this.left, this.right]);
  int value;
  TreeNode? left;
  TreeNode? right;
}

int maxDepth(TreeNode? root) {
  if (root == null) return 0;
  return 1 + max(maxDepth(root.left), maxDepth(root.right));
}
