// Q10. Kth Smallest Element in a BST (Kth Cheapest in a Price Index)
// Source: book/part-viii/34-linked-lists-trees.md
import { TreeNode } from '../common/nodes';

function kthSmallest(root: TreeNode | null, k: number): number {
  const stack: TreeNode[] = [];
  let cur = root;
  let count = 0;
  while (cur || stack.length) {
    while (cur) { // walk left as far as possible
      stack.push(cur);
      cur = cur.left;
    }
    const node = stack.pop()!;
    if (++count === k) return node.val; // in-order visits values ascending
    cur = node.right;
  }
  throw new Error("k > number of nodes");
}

export {};
