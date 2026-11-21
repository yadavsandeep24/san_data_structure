// Q14. Invert Binary Tree
// Source: book/part-viii/29-interview-questions-q11-q20.md
import { TreeNode } from '../common/nodes';

function invertTree(root: TreeNode | null): TreeNode | null {
  if (!root) return null;
  const tmp = root.left;
  root.left = invertTree(root.right);
  root.right = invertTree(tmp);
  return root;
}

export {};
