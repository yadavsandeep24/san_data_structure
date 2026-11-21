// Q3. Pacific Atlantic Water Flow (Map Tiles Draining to Both Coasts)
// Source: book/part-viii/36-graphs-dynamic-programming.md

List<List<int>> pacificAtlantic(List<List<int>> heights) {
  final rows = heights.length, cols = heights[0].length;
  const dirs = [1, 0, -1, 0, 1];
  List<bool> flood(List<int> seeds) { // walk uphill from the ocean
    final seen = List<bool>.filled(rows * cols, false);
    final queue = <int>[];
    for (final s in seeds) {
      if (!seen[s]) { seen[s] = true; queue.add(s); }
    }
    for (var head = 0; head < queue.length; head++) {
      final cell = queue[head];
      final r = cell ~/ cols, c = cell % cols;
      for (var d = 0; d < 4; d++) {
        final nr = r + dirs[d], nc = c + dirs[d + 1];
        if (nr < 0 || nr >= rows || nc < 0 || nc >= cols) continue;
        final next = nr * cols + nc;
        if (!seen[next] && heights[nr][nc] >= heights[r][c]) {
          seen[next] = true;
          queue.add(next);
        }
      }
    }
    return seen;
  }
  final pacific = flood([for (var c = 0; c < cols; c++) c, for (var r = 0; r < rows; r++) r * cols]);
  final atlantic = flood([
    for (var c = 0; c < cols; c++) (rows - 1) * cols + c,
    for (var r = 0; r < rows; r++) r * cols + cols - 1,
  ]);
  return [
    for (var i = 0; i < rows * cols; i++)
      if (pacific[i] && atlantic[i]) [i ~/ cols, i % cols],
  ];
}
