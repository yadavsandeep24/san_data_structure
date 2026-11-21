// Q2. Rotting Oranges (Offline Update Spread)
// Source: book/part-viii/36-graphs-dynamic-programming.md

function orangesRotting(grid: number[][]): number {
  const rows = grid.length, cols = grid[0].length;
  let queue: number[] = [];
  let fresh = 0;
  for (let r = 0; r < rows; r++) {
    for (let c = 0; c < cols; c++) {
      if (grid[r][c] === 2) queue.push(r * cols + c);
      else if (grid[r][c] === 1) fresh++;
    }
  }
  const dirs = [1, 0, -1, 0, 1];
  let minutes = 0;
  while (queue.length > 0 && fresh > 0) {
    const next: number[] = []; // the next BFS layer = the next minute
    for (const cell of queue) {
      for (let d = 0; d < 4; d++) {
        const nr = Math.floor(cell / cols) + dirs[d], nc = (cell % cols) + dirs[d + 1];
        if (nr >= 0 && nr < rows && nc >= 0 && nc < cols && grid[nr][nc] === 1) {
          grid[nr][nc] = 2;
          fresh--;
          next.push(nr * cols + nc);
        }
      }
    }
    queue = next;
    minutes++;
  }
  return fresh === 0 ? minutes : -1;
}

export {};
