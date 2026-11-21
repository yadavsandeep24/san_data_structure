// File system as a tree
// Source: book/part-iii/09-trees-basics.md

class FsNode {
  FsNode(this.name, {this.isDirectory = false, this.children = const []});
  final String name;
  final bool isDirectory;
  final List<FsNode> children;
  bool get isFile => !isDirectory;
}

void walk(FsNode n, void Function(FsNode) visit) {
  visit(n);
  for (final c in n.children) walk(c, visit);
}
