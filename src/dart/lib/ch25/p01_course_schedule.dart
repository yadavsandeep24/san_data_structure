// P1: Course schedule
// Source: solutions/ch25/README.md

bool canFinish(int numCourses, List<List<int>> prerequisites) {
  final g = List.generate(numCourses, (_) => <int>[]);
  final indeg = List.filled(numCourses, 0);
  for (final p in prerequisites) {
    final a = p[0], b = p[1];
    g[b].add(a);
    indeg[a]++;
  }
  final q = <int>[for (var i = 0; i < numCourses; i++) if (indeg[i] == 0) i];
  var head = 0, seen = 0;
  while (head < q.length) {
    final u = q[head++];
    seen++;
    for (final v in g[u]) {
      if (--indeg[v] == 0) q.add(v);
    }
  }
  return seen == numCourses;
}
