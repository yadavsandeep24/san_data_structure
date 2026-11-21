// Q2. Rotting Oranges (Offline Update Spread)
// Source: book/part-viii/36-graphs-dynamic-programming.md

int orangesRotting(List<List<int>> grid) {
  final rows = grid.length, cols = grid[0].length;
  var queue = <int>[];
  var fresh = 0;
  for (var r = 0; r < rows; r++) {
    for (var c = 0; c < cols; c++) {
      if (grid[r][c] == 2) {
        queue.add(r * cols + c);
      } else if (grid[r][c] == 1) {
        fresh++;
      }
    }
  }
  const dirs = [1, 0, -1, 0, 1];
  var minutes = 0;
  while (queue.isNotEmpty && fresh > 0) {
    final next = <int>[]; // the next BFS layer = the next minute
    for (final cell in queue) {
      for (var d = 0; d < 4; d++) {
        final nr = cell ~/ cols + dirs[d], nc = cell % cols + dirs[d + 1];
        if (nr >= 0 && nr < rows && nc >= 0 && nc < cols && grid[nr][nc] == 1) {
          grid[nr][nc] = 2;
          fresh--;
          next.add(nr * cols + nc);
        }
      }
    }
    queue = next;
    minutes++;
  }
  return fresh == 0 ? minutes : -1;
}
