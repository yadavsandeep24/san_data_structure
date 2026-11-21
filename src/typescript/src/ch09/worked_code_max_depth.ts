// Worked code: max depth
// Source: book/part-iii/09-trees-basics.md
import { TreeNode } from '../common/nodes';

function maxDepth(root: TreeNode | null): number {
  if (!root) return 0;
  return 1 + Math.max(maxDepth(root.left), maxDepth(root.right));
}

export {};
