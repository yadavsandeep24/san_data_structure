// Q18. Parallel Courses or Minimum Semesters
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md

int minimumSemesters(int n, List<List<int>> relations) {
  final g = List.generate(n + 1, (_) => <int>[]);
  final indeg = List.filled(n + 1, 0);
  for (final e in relations) {
    g[e[0]].add(e[1]);
    indeg[e[1]]++;
  }
  var q = [for (var i = 1; i <= n; i++) if (indeg[i] == 0) i];
  var sem = 0, taken = 0;
  while (q.isNotEmpty) {
    sem++;
    final next = <int>[];
    for (final u in q) {
      taken++;
      for (final v in g[u]) {
        if (--indeg[v] == 0) next.add(v);
      }
    }
    q = next;
  }
  return taken == n ? sem : -1;
}
