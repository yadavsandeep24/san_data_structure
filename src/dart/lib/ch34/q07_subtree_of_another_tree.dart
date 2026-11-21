// Q7. Subtree of Another Tree (Find a Component Pattern)
// Source: book/part-viii/34-linked-lists-trees.md
import '../common/nodes.dart';

bool isSubtree(TreeNode? root, TreeNode? subRoot) {
  bool same(TreeNode? a, TreeNode? b) {
    if (a == null || b == null) return identical(a, b);
    return a.val == b.val && same(a.left, b.left) && same(a.right, b.right);
  }

  if (subRoot == null) return true;
  if (root == null) return false;
  return same(root, subRoot) || isSubtree(root.left, subRoot) || isSubtree(root.right, subRoot);
}
