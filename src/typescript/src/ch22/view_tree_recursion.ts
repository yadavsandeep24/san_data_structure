// View-tree recursion (mobile-shaped)
// Source: book/part-vi/22-recursion-backtracking.md

type ViewNode = { id: string; children?: ViewNode[] };

function countLeaves(node: ViewNode): number {
  const kids = node.children ?? [];
  if (!kids.length) return 1;
  return kids.reduce((s, c) => s + countLeaves(c), 0);
}

export {};
