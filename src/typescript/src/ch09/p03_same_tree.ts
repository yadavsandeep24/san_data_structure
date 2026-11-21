// P3: Same tree
// Source: solutions/ch09/README.md
import { TreeNode } from '../common/nodes';

function isSameTree(p: TreeNode | null, q: TreeNode | null): boolean {
  if (!p && !q) return true;
  if (!p || !q || p.val !== q.val) return false;
  return isSameTree(p.left, q.left) && isSameTree(p.right, q.right);
}

export {};
