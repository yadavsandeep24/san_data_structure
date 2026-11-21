// Q5. Diameter of Binary Tree (Longest Path in a View Tree)
// Source: book/part-viii/34-linked-lists-trees.md
import { TreeNode } from '../common/nodes';

function diameterOfBinaryTree(root: TreeNode | null): number {
  let best = 0;
  const height = (node: TreeNode | null): number => { // nodes on the longest downward path
    if (!node) return 0;
    const l = height(node.left);
    const r = height(node.right);
    best = Math.max(best, l + r); // longest path bending at this node
    return 1 + Math.max(l, r);
  };
  height(root);
  return best;
}

export {};
