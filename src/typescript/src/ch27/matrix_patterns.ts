// Matrix patterns
// Source: book/part-vii/27-bits-matrix.md

function rotate(matrix: number[][]): void {
  const n = matrix.length;
  for (let i = 0; i < n; i++) {
    for (let j = i; j < n; j++) {
      [matrix[i][j], matrix[j][i]] = [matrix[j][i], matrix[i][j]];
    }
  }
  for (const row of matrix) row.reverse();
}

function floodFill(image: number[][], sr: number, sc: number, newColor: number): void {
  const old = image[sr][sc];
  if (old === newColor) return;
  const dfs = (r: number, c: number) => {
    if (r < 0 || c < 0 || r >= image.length || c >= image[0].length) return;
    if (image[r][c] !== old) return;
    image[r][c] = newColor;
    dfs(r + 1, c); dfs(r - 1, c); dfs(r, c + 1); dfs(r, c - 1);
  };
  dfs(sr, sc);
}

function singleNumber(nums: number[]): number {
  return nums.reduce((a, x) => a ^ x, 0);
}

function numIslands(grid: string[][]): number {
  let count = 0;
  const rows = grid.length, cols = grid[0]?.length ?? 0;
  const dfs = (r: number, c: number) => {
    if (r < 0 || c < 0 || r >= rows || c >= cols || grid[r][c] !== "1") return;
    grid[r][c] = "0";
    dfs(r + 1, c); dfs(r - 1, c); dfs(r, c + 1); dfs(r, c - 1);
  };
  for (let r = 0; r < rows; r++) {
    for (let c = 0; c < cols; c++) {
      if (grid[r][c] === "1") {
        count++;
        dfs(r, c);
      }
    }
  }
  return count;
}

export {};
