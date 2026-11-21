// Q21. Number of Provinces (Connected Components)
// Source: book/part-viii/29-interview-questions-q21-q30.md

int findCircleNum(List<List<int>> isConnected) {
  final n = isConnected.length;
  final seen = List<bool>.filled(n, false);
  void dfs(int i) {
    seen[i] = true;
    for (var j = 0; j < n; j++) {
      if (isConnected[i][j] == 1 && !seen[j]) dfs(j);
    }
  }
  var provinces = 0;
  for (var i = 0; i < n; i++) {
    if (!seen[i]) { provinces++; dfs(i); }
  }
  return provinces;
}
