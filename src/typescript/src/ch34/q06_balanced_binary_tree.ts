// Q6. Balanced Binary Tree (Layout Depth Check)
// Source: book/part-viii/34-linked-lists-trees.md
import { TreeNode } from '../common/nodes';

function isBalanced(root: TreeNode | null): boolean {
  const height = (node: TreeNode | null): number => { // -1 means "already unbalanced"
    if (!node) return 0;
    const l = height(node.left);
    if (l === -1) return -1;
    const r = height(node.right);
    if (r === -1 || Math.abs(l - r) > 1) return -1;
    return 1 + Math.max(l, r);
  };
  return height(root) !== -1;
}

export {};
