// Pattern: same tree
// Source: book/part-iii/09-trees-basics.md
import { TreeNode } from '../common/nodes';

function isSameTree(p: TreeNode | null, q: TreeNode | null): boolean {
  if (!p && !q) return true;
  if (!p || !q) return false;
  if (p.value !== q.value) return false;
  return isSameTree(p.left, q.left) && isSameTree(p.right, q.right);
}

export {};
