// Pattern: number of provinces (connected components)
// Source: book/part-iii/11-graphs-intro.md

int findCircleNum(List<List<int>> isConnected) {
  final n = isConnected.length;
  final seen = List<bool>.filled(n, false);
  var count = 0;
  void dfs(int u) {
    seen[u] = true;
    for (var v = 0; v < n; v++) {
      if (isConnected[u][v] == 1 && !seen[v]) dfs(v);
    }
  }
  for (var i = 0; i < n; i++) {
    if (!seen[i]) {
      count++;
      dfs(i);
    }
  }
  return count;
}
