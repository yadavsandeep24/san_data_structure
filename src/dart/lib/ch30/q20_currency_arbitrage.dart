// Q20 — Currency arbitrage (Swift / Dart)
// Source: solutions/ch30/README.md
import 'dart:math';

bool hasArbitrage(List<(String, String, double)> pairs) {
  final nodes = <String>{};
  for (final (a, b, _) in pairs) {
    nodes.add(a);
    nodes.add(b);
  }
  final list = nodes.toList();
  final idx = {for (var i = 0; i < list.length; i++) list[i]: i};
  final n = list.length;
  final edges = pairs
      .map((e) => (idx[e.$1]!, idx[e.$2]!, -log(e.$3)))
      .toList();
  final dist = List.filled(n, 0.0);
  for (var i = 0; i < n - 1; i++) {
    for (final (u, v, w) in edges) {
      if (dist[v] > dist[u] + w) dist[v] = dist[u] + w;
    }
  }
  for (final (u, v, w) in edges) {
    if (dist[v] > dist[u] + w + 1e-12) return true;
  }
  return false;
}
