// Q13. Binary Tree Maximum Path Sum
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md
import 'dart:math';
import '../common/nodes.dart';

int maxPathSum(TreeNode root) {
  var best = root.val; // any real path beats a sentinel
  int gain(TreeNode? n) {
    if (n == null) return 0;
    final l = max(0, gain(n.left));
    final r = max(0, gain(n.right));
    best = max(best, n.val + l + r);
    return n.val + max(l, r);
  }

  gain(root);
  return best;
}
