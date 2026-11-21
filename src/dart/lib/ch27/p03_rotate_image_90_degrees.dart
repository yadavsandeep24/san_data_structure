// P3: Rotate image 90 degrees
// Source: solutions/ch27/README.md

void rotate(List<List<int>> matrix) {
  final n = matrix.length;
  for (var i = 0; i < n; i++) {
    for (var j = i; j < n; j++) {
      final tmp = matrix[i][j];
      matrix[i][j] = matrix[j][i];
      matrix[j][i] = tmp;
    }
  }
  for (var i = 0; i < n; i++) {
    final row = matrix[i];
    var L = 0, R = n - 1;
    while (L < R) {
      final tmp = row[L];
      row[L] = row[R];
      row[R] = tmp;
      L++;
      R--;
    }
  }
}
