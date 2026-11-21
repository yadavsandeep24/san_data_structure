// Q17. Lowest Common Ancestor of BST
// Source: book/part-viii/29-interview-questions-q11-q20.md
import { TreeNode } from '../common/nodes';

function lowestCommonAncestor(root: TreeNode | null, p: TreeNode | null, q: TreeNode | null): TreeNode | null {
  let cur = root;
  const a = p!.val, b = q!.val;
  while (cur) {
    if (a < cur.val && b < cur.val) cur = cur.left;
    else if (a > cur.val && b > cur.val) cur = cur.right;
    else return cur;
  }
  return null;
}

export {};
