// Q7. Alien Dictionary (Harder Graph Variant)
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md
import 'dart:collection';

String alienOrder(List<String> words) {
  final adj = <String, Set<String>>{};
  final indeg = <String, int>{};
  for (final w in words) {
    for (final c in w.split('')) {
      adj.putIfAbsent(c, () => <String>{});
      indeg.putIfAbsent(c, () => 0);
    }
  }
  for (var i = 0; i + 1 < words.length; i++) {
    final a = words[i], b = words[i + 1];
    if (a.length > b.length && a.startsWith(b)) return '';
    final n = a.length < b.length ? a.length : b.length;
    for (var j = 0; j < n; j++) {
      if (a[j] != b[j]) {
        if (adj[a[j]]!.add(b[j])) indeg[b[j]] = indeg[b[j]]! + 1;
        break;
      }
    }
  }
  final q = Queue<String>()..addAll([for (final e in indeg.entries) if (e.value == 0) e.key]);
  final sb = StringBuffer();
  while (q.isNotEmpty) {
    final u = q.removeFirst();
    sb.write(u);
    for (final v in adj[u]!) {
      indeg[v] = indeg[v]! - 1;
      if (indeg[v] == 0) q.add(v);
    }
  }
  return sb.length == indeg.length ? sb.toString() : '';
}
