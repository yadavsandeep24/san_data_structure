// Q8. Spiral Matrix (Onboarding Tile Reveal Order)
// Source: book/part-viii/31-arrays-hashing-matrix.md

List<int> spiralOrder(List<List<int>> matrix) {
  final out = <int>[];
  if (matrix.isEmpty) return out;
  var top = 0, bottom = matrix.length - 1;
  var left = 0, right = matrix[0].length - 1;
  while (top <= bottom && left <= right) {
    for (var c = left; c <= right; c++) out.add(matrix[top][c]);
    top++;
    for (var r = top; r <= bottom; r++) out.add(matrix[r][right]);
    right--;
    if (top <= bottom) {
      for (var c = right; c >= left; c--) out.add(matrix[bottom][c]);
      bottom--;
    }
    if (left <= right) {
      for (var r = bottom; r >= top; r--) out.add(matrix[r][left]);
      left++;
    }
  }
  return out;
}
