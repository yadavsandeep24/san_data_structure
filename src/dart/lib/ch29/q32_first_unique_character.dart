// Q32. First Unique Character
// Source: book/part-viii/29-interview-questions-q31-q40.md

int firstUniqChar(String s) {
  final freq = <String, int>{};
  for (var i = 0; i < s.length; i++) {
    final c = s[i];
    freq[c] = (freq[c] ?? 0) + 1;
  }
  for (var i = 0; i < s.length; i++) if (freq[s[i]] == 1) return i;
  return -1;
}
