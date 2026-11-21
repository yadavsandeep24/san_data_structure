// P3: Connected components or redundant connection
// Source: solutions/ch25/README.md

class UnionFind {
  final List<int> parent;
  final List<int> rank;
  int components;
  UnionFind(int n)
      : parent = List.generate(n, (i) => i),
        rank = List.filled(n, 0),
        components = n;
  int find(int x) {
    if (parent[x] != x) parent[x] = find(parent[x]);
    return parent[x];
  }
  bool union(int a, int b) {
    var ra = find(a), rb = find(b);
    if (ra == rb) return false;
    if (rank[ra] < rank[rb]) {
      final t = ra;
      ra = rb;
      rb = t;
    }
    parent[rb] = ra;
    if (rank[ra] == rank[rb]) rank[ra]++;
    components--;
    return true;
  }
}

int countComponents(int n, List<List<int>> edges) {
  final uf = UnionFind(n);
  for (final e in edges) {
    uf.union(e[0], e[1]);
  }
  return uf.components;
}

List<int> findRedundantConnection(List<List<int>> edges) {
  final uf = UnionFind(edges.length + 1);
  for (final e in edges) {
    if (!uf.union(e[0], e[1])) return e;
  }
  return [];
}
