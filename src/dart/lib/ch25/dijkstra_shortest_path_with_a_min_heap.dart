// Dijkstra — shortest path with a min-heap
// Source: book/part-vii/25-graphs-advanced.md
import 'package:collection/collection.dart';

int networkDelayTime(List<List<int>> times, int n, int k) {
  final g = List.generate(n + 1, (_) => <(int, int)>[]);
  for (final t in times) {
    g[t[0]].add((t[1], t[2]));
  }
  final dist = List.filled(n + 1, 1 << 30);
  dist[k] = 0;
  final pq = HeapPriorityQueue<(int, int)>((a, b) => a.$1.compareTo(b.$1));
  pq.add((0, k));
  while (pq.isNotEmpty) {
    final (d, u) = pq.removeFirst();
    if (d > dist[u]) continue;
    for (final (v, w) in g[u]) {
      if (d + w < dist[v]) {
        dist[v] = d + w;
        pq.add((dist[v], v));
      }
    }
  }
  final ans = dist.skip(1).reduce((a, b) => a > b ? a : b);
  return ans >= (1 << 30) ? -1 : ans;
}
