// Q17. Bus Routes (Hard BFS)
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md

int numBusesToDestination(List<List<int>> routes, int source, int target) {
  if (source == target) return 0;
  final stopToBus = <int, List<int>>{};
  for (var b = 0; b < routes.length; b++) {
    for (final s in routes[b]) {
      (stopToBus[s] ??= []).add(b);
    }
  }
  var q = [source];
  final seenBus = List.filled(routes.length, false);
  final seenStop = {source};
  var buses = 0;
  while (q.isNotEmpty) {
    buses++;
    final next = <int>[];
    for (final stop in q) {
      for (final b in stopToBus[stop] ?? const <int>[]) {
        if (seenBus[b]) continue;
        seenBus[b] = true;
        for (final ns in routes[b]) {
          if (ns == target) return buses;
          if (seenStop.add(ns)) next.add(ns);
        }
      }
    }
    q = next;
  }
  return -1;
}
