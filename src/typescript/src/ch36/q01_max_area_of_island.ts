// Q1. Max Area of Island (Largest Heatmap Region)
// Source: book/part-viii/36-graphs-dynamic-programming.md

function maxAreaOfIsland(grid: number[][]): number {
  const rows = grid.length, cols = grid[0].length;
  const dirs = [1, 0, -1, 0, 1];
  let best = 0;
  for (let r = 0; r < rows; r++) {
    for (let c = 0; c < cols; c++) {
      if (grid[r][c] !== 1) continue;
      grid[r][c] = 2; // visited
      const stack = [r * cols + c];
      let area = 0;
      while (stack.length > 0) {
        const cell = stack.pop()!;
        area++;
        const cr = Math.floor(cell / cols), cc = cell % cols;
        for (let d = 0; d < 4; d++) {
          const nr = cr + dirs[d], nc = cc + dirs[d + 1];
          if (nr >= 0 && nr < rows && nc >= 0 && nc < cols && grid[nr][nc] === 1) {
            grid[nr][nc] = 2;
            stack.push(nr * cols + nc);
          }
        }
      }
      best = Math.max(best, area);
    }
  }
  return best;
}

export {};
