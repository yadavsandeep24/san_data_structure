// P2: Number of islands
// Source: solutions/ch27/README.md

int numIslands(List<List<String>> grid) {
  if (grid.isEmpty) return 0;
  final rows = grid.length, cols = grid[0].length;
  var count = 0;
  void dfs(int r, int c) {
    if (r < 0 || c < 0 || r >= rows || c >= cols || grid[r][c] != '1') return;
    grid[r][c] = '0';
    dfs(r + 1, c);
    dfs(r - 1, c);
    dfs(r, c + 1);
    dfs(r, c - 1);
  }

  for (var r = 0; r < rows; r++) {
    for (var c = 0; c < cols; c++) {
      if (grid[r][c] == '1') {
        count++;
        dfs(r, c);
      }
    }
  }
  return count;
}
