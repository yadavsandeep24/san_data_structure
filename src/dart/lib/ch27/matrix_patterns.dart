// Matrix patterns
// Source: book/part-vii/27-bits-matrix.md

int numIslands(List<List<String>> grid) {
  final rows = grid.length, cols = grid.isEmpty ? 0 : grid[0].length;
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

void rotate(List<List<int>> matrix) {
  final n = matrix.length;
  for (var i = 0; i < n; i++) {
    for (var j = i; j < n; j++) {
      final t = matrix[i][j];
      matrix[i][j] = matrix[j][i];
      matrix[j][i] = t;
    }
  }
  for (var i = 0; i < n; i++) {
    matrix[i] = matrix[i].reversed.toList();
  }
}

void floodFill(List<List<int>> image, int sr, int sc, int newColor) {
  final old = image[sr][sc];
  if (old == newColor) return;
  void dfs(int r, int c) {
    if (r < 0 || c < 0 || r >= image.length || c >= image[0].length) return;
    if (image[r][c] != old) return;
    image[r][c] = newColor;
    dfs(r + 1, c);
    dfs(r - 1, c);
    dfs(r, c + 1);
    dfs(r, c - 1);
  }
  dfs(sr, sc);
}
