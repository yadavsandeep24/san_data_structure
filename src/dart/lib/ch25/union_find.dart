// Union-Find (Disjoint Set Union)
// Source: book/part-vii/25-graphs-advanced.md

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
