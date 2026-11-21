// Q12. Edit Distance
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md
import 'dart:math';

int minDistance(String word1, String word2) {
  final m = word1.length, n = word2.length;
  var prev = List.generate(n + 1, (j) => j);
  for (var i = 1; i <= m; i++) {
    final cur = List.filled(n + 1, 0);
    cur[0] = i;
    for (var j = 1; j <= n; j++) {
      cur[j] = word1[i - 1] == word2[j - 1]
          ? prev[j - 1]
          : 1 + min(min(prev[j], cur[j - 1]), prev[j - 1]);
    }
    prev = cur;
  }
  return prev[n];
}
