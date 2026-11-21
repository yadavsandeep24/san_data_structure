// P2: Network delay time
// Source: solutions/ch25/README.md
import 'package:collection/collection.dart';

int networkDelayTime(List<List<int>> times, int n, int k) {
  final g = List.generate(n + 1, (_) => <(int, int)>[]);
  for (final t in times) {
    g[t[0]].add((t[1], t[2]));
  }
  const inf = 1 << 30;
  final dist = List.filled(n + 1, inf);
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
  var ans = 0;
  for (var i = 1; i <= n; i++) {
    if (dist[i] >= inf) return -1;
    if (dist[i] > ans) ans = dist[i];
  }
  return ans;
}
