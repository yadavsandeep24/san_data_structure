// P2: Group by key or frequency
// Source: solutions/ch07/README.md

List<List<String>> groupAnagrams(List<String> strs) {
  final map = <String, List<String>>{};
  for (final s in strs) {
    final key = String.fromCharCodes(s.runes.toList()..sort());
    map.putIfAbsent(key, () => []).add(s);
  }
  return map.values.toList();
}
