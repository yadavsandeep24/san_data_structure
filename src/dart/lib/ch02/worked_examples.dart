// Worked examples (four languages)
// Source: book/part-i/02-big-o-notation.md

Map<String, int> frequencies(List<String> ids) {
  final counts = <String, int>{};                 // O(u) space
  for (final id in ids) {                         // Θ(n)
    counts[id] = (counts[id] ?? 0) + 1;           // O(1) average
  }
  return counts;
}
