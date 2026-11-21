// Q11. Construct Binary Tree from Preorder and Inorder Traversal (Rebuild a Tree from Two Dumps)
// Source: book/part-viii/34-linked-lists-trees.md
import '../common/nodes.dart';

TreeNode? buildTree(List<int> preorder, List<int> inorder) {
  final inIndex = <int, int>{};
  for (var i = 0; i < inorder.length; i++) inIndex[inorder[i]] = i;
  var pre = 0;
  TreeNode? build(int lo, int hi) { // inorder window [lo, hi]
    if (lo > hi) return null;
    final node = TreeNode(preorder[pre++]);
    final mid = inIndex[node.val]!;
    node.left = build(lo, mid - 1);
    node.right = build(mid + 1, hi);
    return node;
  }
  return build(0, inorder.length - 1);
}
