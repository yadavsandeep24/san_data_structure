// P3: First unique character
// Source: solutions/ch07/README.md

int firstUniqChar(String s) {
  final runes = s.runes.toList();
  final freq = <int, int>{};
  for (final r in runes) {
    freq[r] = (freq[r] ?? 0) + 1;
  }
  for (var i = 0; i < runes.length; i++) {
    if (freq[runes[i]] == 1) return i;
  }
  return -1;
}
