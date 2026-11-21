// Q8. Binary Tree Right Side View (What the Right Edge Shows)
// Source: book/part-viii/34-linked-lists-trees.md
import '../common/nodes.dart';

List<int> rightSideView(TreeNode? root) {
  final out = <int>[];
  if (root == null) return out;
  var level = [root];
  while (level.isNotEmpty) {
    out.add(level.last.val); // last node of this level
    final next = <TreeNode>[];
    for (final n in level) {
      if (n.left != null) next.add(n.left!);
      if (n.right != null) next.add(n.right!);
    }
    level = next;
  }
  return out;
}
