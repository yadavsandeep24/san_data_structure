// Traversals
// Source: book/part-iii/09-trees-basics.md
import 'dart:collection';
import '../common/nodes.dart';

void preorder(TreeNode? n, void Function(int) visit) {
  if (n == null) return;
  visit(n.value);
  preorder(n.left, visit);
  preorder(n.right, visit);
}

void inorder(TreeNode? n, void Function(int) visit) {
  if (n == null) return;
  inorder(n.left, visit);
  visit(n.value);
  inorder(n.right, visit);
}

void postorder(TreeNode? n, void Function(int) visit) {
  if (n == null) return;
  postorder(n.left, visit);
  postorder(n.right, visit);
  visit(n.value);
}


List<List<int>> levelOrder(TreeNode? root) {
  if (root == null) return [];
  final res = <List<int>>[];
  final q = Queue<TreeNode>()..add(root);
  while (q.isNotEmpty) {
    final level = <int>[];
    for (var i = q.length; i > 0; i--) {
      final node = q.removeFirst();
      level.add(node.value);
      if (node.left != null) q.add(node.left!);
      if (node.right != null) q.add(node.right!);
    }
    res.add(level);
  }
  return res;
}
