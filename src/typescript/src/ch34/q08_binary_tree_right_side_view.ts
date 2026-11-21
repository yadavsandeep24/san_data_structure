// Q8. Binary Tree Right Side View (What the Right Edge Shows)
// Source: book/part-viii/34-linked-lists-trees.md
import { TreeNode } from '../common/nodes';

function rightSideView(root: TreeNode | null): number[] {
  const out: number[] = [];
  if (!root) return out;
  let level: TreeNode[] = [root];
  while (level.length) {
    out.push(level[level.length - 1].val); // last node of this level
    const next: TreeNode[] = [];
    for (const n of level) {
      if (n.left) next.push(n.left);
      if (n.right) next.push(n.right);
    }
    level = next;
  }
  return out;
}

export {};
