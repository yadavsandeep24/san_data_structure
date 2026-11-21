// Q4. Surrounded Regions (Paint Bucket Capture)
// Source: book/part-viii/36-graphs-dynamic-programming.md

void solve(List<List<String>> board) {
  final rows = board.length, cols = board[0].length;
  final stack = <int>[];
  void mark(int r, int c) {
    if (r < 0 || r >= rows || c < 0 || c >= cols || board[r][c] != 'O') return;
    board[r][c] = 'S'; // safe: connected to the border
    stack.add(r * cols + c);
  }

  for (var r = 0; r < rows; r++) {
    mark(r, 0);
    mark(r, cols - 1);
  }
  for (var c = 0; c < cols; c++) {
    mark(0, c);
    mark(rows - 1, c);
  }
  while (stack.isNotEmpty) {
    final cell = stack.removeLast();
    final r = cell ~/ cols, c = cell % cols;
    mark(r + 1, c);
    mark(r - 1, c);
    mark(r, c + 1);
    mark(r, c - 1);
  }
  for (final row in board) {
    for (var c = 0; c < cols; c++) {
      row[c] = row[c] == 'S' ? 'O' : (row[c] == 'O' ? 'X' : row[c]); // leftover 'O' is enclosed
    }
  }
}
