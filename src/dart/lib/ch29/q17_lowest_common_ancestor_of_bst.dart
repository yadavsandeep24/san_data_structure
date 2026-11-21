// Q17. Lowest Common Ancestor of BST
// Source: book/part-viii/29-interview-questions-q11-q20.md
import '../common/nodes.dart';

TreeNode? lowestCommonAncestor(TreeNode? root, TreeNode? p, TreeNode? q) {
  var cur = root;
  final a = p!.val, b = q!.val;
  while (cur != null) {
    if (a < cur.val && b < cur.val) cur = cur.left;
    else if (a > cur.val && b > cur.val) cur = cur.right;
    else return cur;
  }
  return null;
}
