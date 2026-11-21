// P2: Invert binary tree
// Source: solutions/ch09/README.md
import '../common/nodes.dart';

TreeNode? invertTree(TreeNode? root) {
  if (root == null) return null;
  final tmp = root.left;
  root.left = invertTree(root.right);
  root.right = invertTree(tmp);
  return root;
}
