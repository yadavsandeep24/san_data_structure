// Binary Search Tree (BST)
// Source: book/part-iii/10-trees-practical.md
import { TreeNode } from '../common/nodes';

function search(root: TreeNode | null, key: number): TreeNode | null {
  let cur = root;
  while (cur) {
    if (key === cur.value) return cur;
    cur = key < cur.value ? cur.left : cur.right;
  }
  return null;
}

function insert(root: TreeNode | null, key: number): TreeNode {
  if (!root) return new TreeNode(key);
  if (key < root.value) root.left = insert(root.left, key);
  else if (key > root.value) root.right = insert(root.right, key);
  // equal: ignore or define multiset policy
  return root;
}

export {};
