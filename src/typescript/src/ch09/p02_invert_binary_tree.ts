// P2: Invert binary tree
// Source: solutions/ch09/README.md
import { TreeNode } from '../common/nodes';

function invertTree(root: TreeNode | null): TreeNode | null {
  if (!root) return null;
  const tmp = root.left;
  root.left = invertTree(root.right);
  root.right = invertTree(tmp);
  return root;
}

export {};
