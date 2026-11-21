// Q9. Count Good Nodes in Binary Tree (Record-High Checkpoints)
// Source: book/part-viii/34-linked-lists-trees.md
import { TreeNode } from '../common/nodes';

function goodNodes(root: TreeNode | null): number {
  const dfs = (node: TreeNode | null, maxSoFar: number): number => {
    if (!node) return 0;
    const good = node.val >= maxSoFar ? 1 : 0;
    const next = Math.max(maxSoFar, node.val);
    return good + dfs(node.left, next) + dfs(node.right, next);
  };
  return dfs(root, -Infinity);
}

export {};
