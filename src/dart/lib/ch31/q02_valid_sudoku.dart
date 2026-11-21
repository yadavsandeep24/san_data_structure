// Q2. Valid Sudoku (Puzzle Board Check)
// Source: book/part-viii/31-arrays-hashing-matrix.md

bool isValidSudoku(List<List<String>> board) {
  final rows = List<int>.filled(9, 0);
  final cols = List<int>.filled(9, 0);
  final boxes = List<int>.filled(9, 0);
  for (var r = 0; r < 9; r++) {
    for (var c = 0; c < 9; c++) {
      final ch = board[r][c];
      if (ch == '.') continue;
      final bit = 1 << (ch.codeUnitAt(0) - 49);
      final b = (r ~/ 3) * 3 + c ~/ 3;
      if ((rows[r] | cols[c] | boxes[b]) & bit != 0) return false;
      rows[r] |= bit;
      cols[c] |= bit;
      boxes[b] |= bit;
    }
  }
  return true;
}
