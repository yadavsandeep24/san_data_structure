// Binary Search Tree (BST)
// Source: book/part-iii/10-trees-practical.md
import '../common/nodes.dart';

TreeNode? search(TreeNode? root, int key) {
  var cur = root;
  while (cur != null) {
    if (key == cur.value) return cur;
    cur = key < cur.value ? cur.left : cur.right;
  }
  return null;
}

TreeNode insert(TreeNode? root, int key) {
  if (root == null) return TreeNode(key);
  if (key < root.value) {
    root.left = insert(root.left, key);
  } else if (key > root.value) {
    root.right = insert(root.right, key);
  }
  // equal: ignore or define multiset policy
  return root;
}
