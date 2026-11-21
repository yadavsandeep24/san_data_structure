// Q16. Regular Expression Matching
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md

bool isMatch(String s, String p) {
  final m = s.length, n = p.length;
  final dp = List.generate(m + 1, (_) => List.filled(n + 1, false));
  dp[0][0] = true;
  for (var j = 2; j <= n; j++) {
    if (p[j - 1] == '*' && dp[0][j - 2]) dp[0][j] = true;
  }
  for (var i = 1; i <= m; i++) {
    for (var j = 1; j <= n; j++) {
      if (p[j - 1] == '*') {
        dp[i][j] = dp[i][j - 2] ||
            ((p[j - 2] == '.' || p[j - 2] == s[i - 1]) && dp[i - 1][j]);
      } else if (p[j - 1] == '.' || p[j - 1] == s[i - 1]) {
        dp[i][j] = dp[i - 1][j - 1];
      }
    }
  }
  return dp[m][n];
}
