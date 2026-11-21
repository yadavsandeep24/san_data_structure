// Q15. Validate BST
// Source: book/part-viii/29-interview-questions-q11-q20.md
import '../common/nodes.dart';

bool isValidBST(TreeNode? root) {
  bool go(TreeNode? n, int? lo, int? hi) {
    if (n == null) return true;
    if (lo != null && n.val <= lo) return false;
    if (hi != null && n.val >= hi) return false;
    return go(n.left, lo, n.val) && go(n.right, n.val, hi);
  }
  return go(root, null, null);
}
