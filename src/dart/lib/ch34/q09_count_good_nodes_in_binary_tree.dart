// Q9. Count Good Nodes in Binary Tree (Record-High Checkpoints)
// Source: book/part-viii/34-linked-lists-trees.md
import '../common/nodes.dart';
import 'dart:math';

int goodNodes(TreeNode? root) {
  int dfs(TreeNode? node, int maxSoFar) {
    if (node == null) return 0;
    final good = node.val >= maxSoFar ? 1 : 0;
    final next = max(maxSoFar, node.val);
    return good + dfs(node.left, next) + dfs(node.right, next);
  }
  return root == null ? 0 : dfs(root, root.val); // the root is always good
}
