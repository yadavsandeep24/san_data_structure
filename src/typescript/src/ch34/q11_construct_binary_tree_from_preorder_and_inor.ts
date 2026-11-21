// Q11. Construct Binary Tree from Preorder and Inorder Traversal (Rebuild a Tree from Two Dumps)
// Source: book/part-viii/34-linked-lists-trees.md
import { TreeNode } from '../common/nodes';

function buildTree(preorder: number[], inorder: number[]): TreeNode | null {
  const inIndex = new Map<number, number>();
  inorder.forEach((v, i) => inIndex.set(v, i));
  let pre = 0; // next root in preorder
  const build = (lo: number, hi: number): TreeNode | null => { // inorder window [lo, hi]
    if (lo > hi) return null;
    const node = new TreeNode(preorder[pre++]);
    const mid = inIndex.get(node.val)!;
    node.left = build(lo, mid - 1);
    node.right = build(mid + 1, hi);
    return node;
  };
  return build(0, inorder.length - 1);
}

export {};
