// P3: Rotate image 90 degrees
// Source: solutions/ch27/README.md

function rotate(matrix: number[][]): void {
  const n = matrix.length;
  for (let i = 0; i < n; i++) {
    for (let j = i; j < n; j++) {
      const tmp = matrix[i][j];
      matrix[i][j] = matrix[j][i];
      matrix[j][i] = tmp;
    }
  }
  for (const row of matrix) row.reverse();
}

export {};
