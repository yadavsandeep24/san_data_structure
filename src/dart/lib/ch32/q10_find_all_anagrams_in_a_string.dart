// Q10. Find All Anagrams in a String (Every Scrambled Match)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

List<int> findAnagrams(String s, String p) {
  final out = <int>[];
  if (p.length > s.length) return out;
  final need = List<int>.filled(26, 0);
  for (final c in p.codeUnits) {
    need[c - 97]++;
  }
  var missing = p.length;
  for (var i = 0; i < s.length; i++) {
    if (need[s.codeUnitAt(i) - 97]-- > 0) missing--;
    if (i >= p.length && ++need[s.codeUnitAt(i - p.length) - 97] > 0) missing++;
    if (missing == 0) out.add(i - p.length + 1);
  }
  return out;
}
