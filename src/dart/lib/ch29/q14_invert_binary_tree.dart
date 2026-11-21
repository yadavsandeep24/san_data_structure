// Q14. Invert Binary Tree
// Source: book/part-viii/29-interview-questions-q11-q20.md
import '../common/nodes.dart';

TreeNode? invertTree(TreeNode? root) {
  if (root == null) return null;
  final tmp = root.left;
  root.left = invertTree(root.right);
  root.right = invertTree(tmp);
  return root;
}
