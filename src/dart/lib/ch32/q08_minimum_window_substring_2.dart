// Q8 — Minimum window substring (Swift / Dart)
// Source: solutions/ch32/README.md

String minWindow(String s, String t) {
  if (t.isEmpty || t.length > s.length) return '';
  final need = List<int>.filled(65536, 0);
  for (final c in t.codeUnits) need[c]++;
  var missing = t.length;
  var left = 0, bestStart = 0, bestLen = -1;
  for (var right = 0; right < s.length; right++) {
    if (need[s.codeUnitAt(right)]-- > 0) missing--;
    while (missing == 0) {
      if (bestLen == -1 || right - left + 1 < bestLen) {
        bestLen = right - left + 1;
        bestStart = left;
      }
      if (++need[s.codeUnitAt(left)] > 0) missing++;
      left++;
    }
  }
  return bestLen == -1 ? '' : s.substring(bestStart, bestStart + bestLen);
}
