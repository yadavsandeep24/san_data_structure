// Worked example 2: is the query a subsequence of the name? (one cursor per sequence)
// Source: book/part-iv/13-two-pointers.md

bool isSubsequence(String query, String name) {
  final q = query.toLowerCase();
  final n = name.toLowerCase();
  var qi = 0;
  for (var ni = 0; ni < n.length && qi < q.length; ni++) {
    if (n.codeUnitAt(ni) == q.codeUnitAt(qi)) qi++;
  }
  return qi == q.length;
}
