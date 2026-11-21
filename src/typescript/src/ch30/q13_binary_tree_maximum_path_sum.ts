// Q13. Binary Tree Maximum Path Sum
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md
import { TreeNode } from '../common/nodes';

function maxPathSum(root: TreeNode | null): number {
  let best = -Infinity;
  function gain(n: TreeNode | null): number {
    if (!n) return 0;
    const l = Math.max(0, gain(n.left));
    const r = Math.max(0, gain(n.right));
    best = Math.max(best, n.val + l + r);
    return n.val + Math.max(l, r);
  }
  gain(root);
  return best;
}

export {};
