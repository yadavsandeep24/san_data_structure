// Q24. Shortest Path in Unweighted Graph
// Source: book/part-viii/29-interview-questions-q21-q30.md

int shortestPath(Map<int, List<int>> g, int start, int end) {
  if (start == end) return 0;
  final seen = <int>{start};
  final q = <int>[start];
  var head = 0, dist = 0;
  while (head < q.length) {
    final size = q.length - head;
    for (var i = 0; i < size; i++) {
      final u = q[head++];
      for (final v in g[u] ?? const <int>[]) {
        if (v == end) return dist + 1;
        if (seen.add(v)) q.add(v);
      }
    }
    dist++;
  }
  return -1;
}
