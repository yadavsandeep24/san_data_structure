// Q5. Graph Valid Tree (Folder Hierarchy Sanity Check)
// Source: book/part-viii/36-graphs-dynamic-programming.md

bool validTree(int n, List<List<int>> edges) {
  if (edges.length != n - 1) return false;
  final parent = List<int>.generate(n, (i) => i);
  final size = List<int>.filled(n, 1);
  int find(int x) {
    while (parent[x] != x) {
      parent[x] = parent[parent[x]]; // path halving
      x = parent[x];
    }
    return x;
  }

  for (final e in edges) {
    final ra = find(e[0]), rb = find(e[1]);
    if (ra == rb) return false; // edge closes a cycle
    if (size[ra] < size[rb]) { // union by size: hang the smaller tree
      parent[ra] = rb;
      size[rb] += size[ra];
    } else {
      parent[rb] = ra;
      size[ra] += size[rb];
    }
  }
  return true;
}
