// Topological sort — Kahn’s algorithm
// Source: book/part-vii/25-graphs-advanced.md

List<int>? topoSort(int n, List<(int, int)> edges) {
  final g = List.generate(n, (_) => <int>[]);
  final indeg = List.filled(n, 0);
  for (final (u, v) in edges) {
    g[u].add(v);
    indeg[v]++;
  }
  final q = <int>[for (var i = 0; i < n; i++) if (indeg[i] == 0) i];
  final order = <int>[];
  var head = 0;
  while (head < q.length) {
    final u = q[head++];
    order.add(u);
    for (final v in g[u]) {
      if (--indeg[v] == 0) q.add(v);
    }
  }
  return order.length == n ? order : null;
}
