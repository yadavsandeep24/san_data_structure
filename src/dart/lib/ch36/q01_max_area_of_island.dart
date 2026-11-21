// Q1. Max Area of Island (Largest Heatmap Region)
// Source: book/part-viii/36-graphs-dynamic-programming.md
import 'dart:math';

int maxAreaOfIsland(List<List<int>> grid) {
  final rows = grid.length, cols = grid[0].length;
  const dirs = [1, 0, -1, 0, 1];
  var best = 0;
  for (var r = 0; r < rows; r++) {
    for (var c = 0; c < cols; c++) {
      if (grid[r][c] != 1) continue;
      grid[r][c] = 2; // visited
      final stack = [r * cols + c];
      var area = 0;
      while (stack.isNotEmpty) {
        final cell = stack.removeLast();
        area++;
        for (var d = 0; d < 4; d++) {
          final nr = cell ~/ cols + dirs[d], nc = cell % cols + dirs[d + 1];
          if (nr >= 0 && nr < rows && nc >= 0 && nc < cols && grid[nr][nc] == 1) {
            grid[nr][nc] = 2;
            stack.add(nr * cols + nc);
          }
        }
      }
      best = max(best, area);
    }
  }
  return best;
}
