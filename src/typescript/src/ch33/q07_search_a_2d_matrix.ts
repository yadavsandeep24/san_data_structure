// Q7. Search a 2D Matrix (Paged Sorted Catalogue)
// Source: book/part-viii/33-stacks-binary-search.md

function searchMatrix(matrix: number[][], target: number): boolean {
  if (matrix.length === 0 || matrix[0].length === 0) return false;
  const cols = matrix[0].length;
  let lo = 0, hi = matrix.length * cols - 1;
  while (lo <= hi) {
    const mid = (lo + hi) >> 1;
    const v = matrix[Math.floor(mid / cols)][mid % cols]; // grid as one sorted array
    if (v === target) return true;
    if (v < target) lo = mid + 1;
    else hi = mid - 1;
  }
  return false;
}

export {};
