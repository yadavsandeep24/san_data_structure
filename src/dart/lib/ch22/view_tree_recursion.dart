// View-tree recursion (mobile-shaped)
// Source: book/part-vi/22-recursion-backtracking.md

class ViewNode {
  final String id;
  final List<ViewNode> children;
  ViewNode(this.id, [this.children = const []]);
}

int countLeaves(ViewNode node) {
  if (node.children.isEmpty) return 1;
  return node.children.fold(0, (s, c) => s + countLeaves(c));
}
