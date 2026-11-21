// Pattern: invert binary tree
// Source: book/part-iii/09-trees-basics.md
import '../common/nodes.dart';

TreeNode? invertTree(TreeNode? root) {
  if (root == null) return null;
  final tmp = root.left;
  root.left = invertTree(root.right);
  root.right = invertTree(tmp);
  return root;
}
