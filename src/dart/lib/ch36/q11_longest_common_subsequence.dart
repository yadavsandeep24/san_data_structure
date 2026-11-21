// Q11. Longest Common Subsequence (Diffing Two Lists)
// Source: book/part-viii/36-graphs-dynamic-programming.md
import 'dart:math';

int longestCommonSubsequence(String a, String b) {
  final dp = List<int>.filled(b.length + 1, 0); // row i-1, overwritten into row i
  for (var i = 1; i <= a.length; i++) {
    var diag = 0; // dp[i-1][j-1]
    for (var j = 1; j <= b.length; j++) {
      final up = dp[j]; // dp[i-1][j]
      dp[j] = a[i - 1] == b[j - 1] ? diag + 1 : max(up, dp[j - 1]);
      diag = up;
    }
  }
  return dp[b.length];
}
