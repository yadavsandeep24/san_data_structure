// P3: Same tree
// Source: solutions/ch09/README.md
import '../common/nodes.dart';

bool isSameTree(TreeNode? p, TreeNode? q) {
  if (p == null && q == null) return true;
  if (p == null || q == null) return false;
  if (p.value != q.value) return false;
  return isSameTree(p.left, q.left) && isSameTree(p.right, q.right);
}
