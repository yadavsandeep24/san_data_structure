// Q4. Word Break
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md
import 'dart:math';

bool wordBreak(String s, List<String> wordDict) {
  final dict = wordDict.toSet();
  final n = s.length;
  final dp = List.filled(n + 1, false);
  dp[0] = true;
  final maxLen = wordDict.fold<int>(0, (m, w) => max(m, w.length));
  for (var i = 0; i < n; i++) {
    if (!dp[i]) continue;
    for (var len = 1; len <= min(maxLen, n - i); len++) {
      if (dict.contains(s.substring(i, i + len))) dp[i + len] = true;
    }
  }
  return dp[n];
}
