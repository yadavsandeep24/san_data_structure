// BFS and DFS
// Source: book/part-iii/11-graphs-intro.md
import 'dart:collection';

List<int> bfs(Map<int, List<int>> graph, int start) {
  final seen = <int>{start};
  final q = Queue<int>()..add(start);
  final order = <int>[];
  while (q.isNotEmpty) {
    final u = q.removeFirst();
    order.add(u);
    for (final v in graph[u] ?? const <int>[]) {
      if (seen.add(v)) q.addLast(v); // mark when enqueued
    }
  }
  return order;
}

List<int> dfs(Map<int, List<int>> graph, int start) {
  final seen = <int>{};
  final order = <int>[];
  void go(int u) {
    seen.add(u);
    order.add(u);
    for (final v in graph[u] ?? const <int>[]) {
      if (!seen.contains(v)) go(v);
    }
  }
  go(start);
  return order;
}
