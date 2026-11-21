// Q7. Search a 2D Matrix (Paged Sorted Catalogue)
// Source: book/part-viii/33-stacks-binary-search.md

bool searchMatrix(List<List<int>> matrix, int target) {
  if (matrix.isEmpty || matrix[0].isEmpty) return false;
  final cols = matrix[0].length;
  var lo = 0, hi = matrix.length * cols - 1;
  while (lo <= hi) {
    final mid = lo + (hi - lo) ~/ 2;
    final v = matrix[mid ~/ cols][mid % cols]; // treat the grid as one sorted array
    if (v == target) return true;
    if (v < target) {
      lo = mid + 1;
    } else {
      hi = mid - 1;
    }
  }
  return false;
}
