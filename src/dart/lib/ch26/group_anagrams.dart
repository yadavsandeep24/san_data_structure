// Group anagrams
// Source: book/part-vii/26-strings.md

List<List<String>> groupAnagrams(List<String> strs) {
  final map = <String, List<String>>{};
  for (final s in strs) {
    final key = String.fromCharCodes(s.runes.toList()..sort());
    map.putIfAbsent(key, () => []).add(s);
  }
  return map.values.toList();
}
