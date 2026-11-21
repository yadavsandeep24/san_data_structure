// Validate BST
// Source: book/part-iii/10-trees-practical.md
import { TreeNode } from '../common/nodes';

function isValidBST(root: TreeNode | null): boolean {
  function go(n: TreeNode | null, lo: number | null, hi: number | null): boolean {
    if (!n) return true;
    if (lo != null && n.value <= lo) return false;
    if (hi != null && n.value >= hi) return false;
    return go(n.left, lo, n.value) && go(n.right, n.value, hi);
  }
  return go(root, null, null);
}

export {};
