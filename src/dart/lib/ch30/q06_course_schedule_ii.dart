// Q6. Course Schedule II (Return Order)
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md

List<int> findOrder(int numCourses, List<List<int>> prerequisites) {
  final g = List.generate(numCourses, (_) => <int>[]);
  final indeg = List.filled(numCourses, 0);
  for (final e in prerequisites) {
    g[e[1]].add(e[0]);
    indeg[e[0]]++;
  }
  // `order` doubles as the queue; `head` is the dequeue pointer.
  final order = [for (var i = 0; i < numCourses; i++) if (indeg[i] == 0) i];
  for (var head = 0; head < order.length; head++) {
    for (final v in g[order[head]]) {
      if (--indeg[v] == 0) order.add(v);
    }
  }
  return order.length == numCourses ? order : [];
}
