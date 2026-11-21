// P3: Shortest path unweighted
// Source: solutions/ch11/README.md
import 'dart:collection';

void example() {
  ({int dist, List<String> path})? shortestPath(
    Map<String, List<String>> graph,
    String src,
    String dst,
  ) {
    if (src == dst) return (dist: 0, path: [src]);
    final parent = <String, String?>{src: null};
    final q = Queue<String>()..add(src);
    while (q.isNotEmpty) {
      final u = q.removeFirst();
      for (final v in graph[u] ?? const []) {
        if (parent.containsKey(v)) continue;
        parent[v] = u;
        if (v == dst) {
          final path = <String>[];
          String? cur = dst;
          while (cur != null) {
            path.add(cur);
            cur = parent[cur];
          }
          return (dist: path.length - 1, path: path.reversed.toList());
        }
        q.addLast(v);
      }
    }
    return null;
  }
}
