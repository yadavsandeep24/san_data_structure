// P1: Validate BST
// Source: solutions/ch10/README.md
import { TreeNode } from '../common/nodes';

function isValidBST(root: TreeNode | null): boolean {
  function go(n: TreeNode | null, lo: number | null, hi: number | null): boolean {
    if (!n) return true;
    if (lo != null && n.val <= lo) return false;
    if (hi != null && n.val >= hi) return false;
    return go(n.left, lo, n.val) && go(n.right, n.val, hi);
  }
  return go(root, null, null);
}

export {};
