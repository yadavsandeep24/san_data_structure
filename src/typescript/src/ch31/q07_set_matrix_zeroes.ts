// Q7. Set Matrix Zeroes (Invalidate Grid Rows and Columns)
// Source: book/part-viii/31-arrays-hashing-matrix.md

function setZeroes(matrix: number[][]): void {
  if (matrix.length === 0) return;
  const m = matrix.length;
  const n = matrix[0].length;
  const firstRowZero = matrix[0].some((v) => v === 0);
  const firstColZero = matrix.some((row) => row[0] === 0);
  for (let r = 1; r < m; r++) {
    for (let c = 1; c < n; c++) {
      if (matrix[r][c] === 0) {
        matrix[r][0] = 0;
        matrix[0][c] = 0;
      }
    }
  }
  for (let r = 1; r < m; r++) {
    for (let c = 1; c < n; c++) {
      if (matrix[r][0] === 0 || matrix[0][c] === 0) matrix[r][c] = 0;
    }
  }
  if (firstRowZero) matrix[0].fill(0);
  if (firstColZero) for (const row of matrix) row[0] = 0;
}

export {};
