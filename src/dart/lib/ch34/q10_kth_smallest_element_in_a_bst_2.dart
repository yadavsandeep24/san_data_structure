// Q10 — Kth smallest element in a BST (Swift / Dart)
// Source: solutions/ch34/README.md
import '../common/nodes.dart';

int kthSmallest(TreeNode? root, int k) {
  final stack = <TreeNode>[];
  var cur = root;
  var count = 0;
  while (cur != null || stack.isNotEmpty) {
    while (cur != null) { // walk left
      stack.add(cur);
      cur = cur.left;
    }
    final node = stack.removeLast();
    if (++count == k) return node.val; // in-order is ascending
    cur = node.right;
  }
  throw ArgumentError('k > number of nodes');
}
