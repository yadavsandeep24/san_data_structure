// Traversals
// Source: book/part-iii/09-trees-basics.md
import { TreeNode } from '../common/nodes';

function preorder(n: TreeNode | null, visit: (v: number) => void): void {
  if (!n) return;
  visit(n.value);
  preorder(n.left, visit);
  preorder(n.right, visit);
}

function inorder(n: TreeNode | null, visit: (v: number) => void): void {
  if (!n) return;
  inorder(n.left, visit);
  visit(n.value);
  inorder(n.right, visit);
}

function postorder(n: TreeNode | null, visit: (v: number) => void): void {
  if (!n) return;
  postorder(n.left, visit);
  postorder(n.right, visit);
  visit(n.value);
}

function levelOrder(root: TreeNode | null): number[][] {
  if (!root) return [];
  const res: number[][] = [];
  const q: TreeNode[] = [root];
  let head = 0; // index-as-queue: shift() is O(n)
  while (head < q.length) {
    const end = q.length;
    const level: number[] = [];
    while (head < end) {
      const node = q[head++];
      level.push(node.value);
      if (node.left) q.push(node.left);
      if (node.right) q.push(node.right);
    }
    res.push(level);
  }
  return res;
}

export {};
