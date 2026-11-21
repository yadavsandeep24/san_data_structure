// P1: Validate BST
// Source: solutions/ch10/README.md
import '../common/nodes.dart';

bool isValidBST(TreeNode? root) {
  bool go(TreeNode? n, int? lo, int? hi) {
    if (n == null) return true;
    if (lo != null && n.value <= lo) return false;
    if (hi != null && n.value >= hi) return false;
    return go(n.left, lo, n.value) && go(n.right, n.value, hi);
  }
  return go(root, null, null);
}
