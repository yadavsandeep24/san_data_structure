// Q5. Diameter of Binary Tree (Longest Path in a View Tree)
// Source: book/part-viii/34-linked-lists-trees.md
import '../common/nodes.dart';
import 'dart:math';

int diameterOfBinaryTree(TreeNode? root) {
  var best = 0;
  int height(TreeNode? node) { // nodes on the longest downward path
    if (node == null) return 0;
    final l = height(node.left);
    final r = height(node.right);
    best = max(best, l + r); // longest path bending at this node
    return 1 + max(l, r);
  }
  height(root);
  return best;
}
