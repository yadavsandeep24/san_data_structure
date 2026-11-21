// Q16. Binary Tree Level Order
// Source: book/part-viii/29-interview-questions-q11-q20.md
import '../common/nodes.dart';

List<List<int>> levelOrder(TreeNode? root) {
  if (root == null) return [];
  final q = <TreeNode>[root];
  final out = <List<int>>[];
  var head = 0;
  while (head < q.length) {
    final level = <int>[];
    final count = q.length - head;
    for (var i = 0; i < count; i++) {
      final n = q[head++];
      level.add(n.val);
      if (n.left != null) q.add(n.left!);
      if (n.right != null) q.add(n.right!);
    }
    out.add(level);
  }
  return out;
}
