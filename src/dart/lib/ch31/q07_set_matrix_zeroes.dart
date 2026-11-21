// Q7. Set Matrix Zeroes (Invalidate Grid Rows and Columns)
// Source: book/part-viii/31-arrays-hashing-matrix.md

void setZeroes(List<List<int>> matrix) {
  if (matrix.isEmpty) return;
  final m = matrix.length;
  final n = matrix[0].length;
  final firstRowZero = matrix[0].contains(0);
  final firstColZero = matrix.any((row) => row[0] == 0);
  for (var r = 1; r < m; r++) {
    for (var c = 1; c < n; c++) {
      if (matrix[r][c] == 0) {
        matrix[r][0] = 0;
        matrix[0][c] = 0;
      }
    }
  }
  for (var r = 1; r < m; r++) {
    for (var c = 1; c < n; c++) {
      if (matrix[r][0] == 0 || matrix[0][c] == 0) matrix[r][c] = 0;
    }
  }
  if (firstRowZero) matrix[0].fillRange(0, n, 0);
  if (firstColZero) {
    for (final row in matrix) {
      row[0] = 0;
    }
  }
}
