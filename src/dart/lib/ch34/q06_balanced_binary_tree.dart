// Q6. Balanced Binary Tree (Layout Depth Check)
// Source: book/part-viii/34-linked-lists-trees.md
import '../common/nodes.dart';
import 'dart:math';

bool isBalanced(TreeNode? root) {
  int height(TreeNode? node) { // -1 means "already unbalanced"
    if (node == null) return 0;
    final l = height(node.left);
    if (l == -1) return -1;
    final r = height(node.right);
    if (r == -1 || (l - r).abs() > 1) return -1;
    return 1 + max(l, r);
  }
  return height(root) != -1;
}
