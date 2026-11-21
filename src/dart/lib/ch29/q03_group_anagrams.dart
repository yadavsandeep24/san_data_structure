// Q3. Group Anagrams (Facet Grouping)
// Source: book/part-viii/29-interview-questions-q01-q10.md

List<List<String>> groupAnagrams(List<String> strs) {
  final m = <String, List<String>>{};
  for (final s in strs) {
    final k = String.fromCharCodes(s.runes.toList()..sort());
    m.putIfAbsent(k, () => []).add(s);
  }
  return m.values.toList();
}
