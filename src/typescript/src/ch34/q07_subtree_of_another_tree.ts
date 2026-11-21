// Q7. Subtree of Another Tree (Find a Component Pattern)
// Source: book/part-viii/34-linked-lists-trees.md
import { TreeNode } from '../common/nodes';

function isSubtree(root: TreeNode | null, subRoot: TreeNode | null): boolean {
  const same = (a: TreeNode | null, b: TreeNode | null): boolean =>
    !a || !b ? a === b : a.val === b.val && same(a.left, b.left) && same(a.right, b.right);

  if (!subRoot) return true;
  if (!root) return false;
  return same(root, subRoot) || isSubtree(root.left, subRoot) || isSubtree(root.right, subRoot);
}

export {};
