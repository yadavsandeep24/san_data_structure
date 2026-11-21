// Q15. Accounts Merge (Union-Find Hard)
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md

List<List<String>> accountsMerge(List<List<String>> accounts) {
  final parent = <String, String>{};
  final emailName = <String, String>{};
  String find(String x) {
    final p = parent[x] ?? x;
    if (p == x) return x;
    final root = find(p);
    parent[x] = root;
    return root;
  }

  void union(String a, String b) => parent[find(a)] = find(b);

  for (final acc in accounts) {
    final name = acc[0];
    for (var i = 1; i < acc.length; i++) {
      final e = acc[i];
      parent.putIfAbsent(e, () => e);
      emailName[e] = name;
      union(acc[1], e);
    }
  }
  final groups = <String, List<String>>{};
  for (final e in parent.keys.toList()) {
    (groups[find(e)] ??= []).add(e);
  }
  return [
    for (final MapEntry(key: root, value: emails) in groups.entries)
      [emailName[root]!, ...(emails..sort())]
  ];
}
