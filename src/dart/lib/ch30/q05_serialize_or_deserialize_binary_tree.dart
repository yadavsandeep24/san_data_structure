// Q5. Serialize or Deserialize Binary Tree
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md
import 'dart:collection';

class TreeNode {
  TreeNode(this.val);
  int val;
  TreeNode? left;
  TreeNode? right;
}

class Codec {
  String serialize(TreeNode? root) {
    if (root == null) return '#';
    final q = Queue<TreeNode?>()..add(root);
    final out = <String>[];
    while (q.isNotEmpty) {
      final n = q.removeFirst();
      if (n == null) {
        out.add('#');
        continue;
      }
      out.add('${n.val}');
      q
        ..add(n.left)
        ..add(n.right);
    }
    return out.join(',');
  }

  TreeNode? deserialize(String data) {
    if (data == '#' || data.isEmpty) return null;
    final parts = data.split(',');
    final root = TreeNode(int.parse(parts[0]));
    final q = Queue<TreeNode>()..add(root);
    var i = 1;
    while (q.isNotEmpty && i < parts.length) {
      final n = q.removeFirst();
      if (parts[i] != '#') {
        final child = TreeNode(int.parse(parts[i]));
        n.left = child;
        q.add(child);
      }
      i++;
      if (i < parts.length && parts[i] != '#') {
        final child = TreeNode(int.parse(parts[i]));
        n.right = child;
        q.add(child);
      }
      i++;
    }
    return root;
  }
}
