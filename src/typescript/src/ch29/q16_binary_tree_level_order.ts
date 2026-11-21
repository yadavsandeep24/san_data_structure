// Q16. Binary Tree Level Order
// Source: book/part-viii/29-interview-questions-q11-q20.md
import { TreeNode } from '../common/nodes';

function levelOrder(root: TreeNode | null): number[][] {
  if (!root) return [];
  const q: TreeNode[] = [root];
  const out: number[][] = [];
  let head = 0;
  while (head < q.length) {
    const size = q.length - head;
    const level: number[] = [];
    for (let i = 0; i < size; i++) {
      const n = q[head++];
      level.push(n.val);
      if (n.left) q.push(n.left);
      if (n.right) q.push(n.right);
    }
    out.push(level);
  }
  return out;
}

export {};
