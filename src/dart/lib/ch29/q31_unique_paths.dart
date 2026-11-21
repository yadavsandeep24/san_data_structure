// Q31. Unique Paths
// Source: book/part-viii/29-interview-questions-q31-q40.md

int uniquePaths(int m, int n) {
  final dp = List<int>.filled(n, 1);
  for (var i = 1; i < m; i++) {
    for (var j = 1; j < n; j++) dp[j] += dp[j - 1];
  }
  return dp[n - 1];
}
