// Q7. Permutation in String (Scrambled Code Search)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

bool checkInclusion(String s1, String s2) {
  if (s1.length > s2.length) return false;
  final need = List<int>.filled(26, 0);
  for (final c in s1.codeUnits) {
    need[c - 97]++;
  }
  var missing = s1.length;
  for (var i = 0; i < s2.length; i++) {
    if (need[s2.codeUnitAt(i) - 97]-- > 0) missing--;
    if (i >= s1.length && ++need[s2.codeUnitAt(i - s1.length) - 97] > 0) missing++;
    if (missing == 0) return true;
  }
  return false;
}
