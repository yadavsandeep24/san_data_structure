// Pattern: shortest path in unweighted graph
// Source: book/part-iii/11-graphs-intro.md
import 'dart:collection';

int? shortestHops(Map<String, List<String>> g, String src, String dst) {
  if (src == dst) return 0;
  final dist = <String, int>{src: 0};
  final q = Queue<String>()..add(src);
  while (q.isNotEmpty) {
    final u = q.removeFirst();
    for (final v in g[u] ?? const []) {
      if (!dist.containsKey(v)) {
        dist[v] = dist[u]! + 1;
        if (v == dst) return dist[v];
        q.addLast(v);
      }
    }
  }
  return null; // unreachable
}
