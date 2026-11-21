// Worked code: max depth
// Source: book/part-iii/09-trees-basics.md
import '../common/nodes.dart';
import 'dart:math';

int maxDepth(TreeNode? root) {
  if (root == null) return 0;
  return 1 + max(maxDepth(root.left), maxDepth(root.right));
}
