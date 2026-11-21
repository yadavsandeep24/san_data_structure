// Q3. Pacific Atlantic Water Flow (Map Tiles Draining to Both Coasts)
// Source: book/part-viii/36-graphs-dynamic-programming.md

function pacificAtlantic(heights: number[][]): number[][] {
  const rows = heights.length, cols = heights[0].length;
  const dirs = [1, 0, -1, 0, 1];
  const flood = (seeds: number[]): boolean[] => { // walk uphill from the ocean
    const seen = new Array<boolean>(rows * cols).fill(false);
    const queue: number[] = [];
    for (const s of seeds) if (!seen[s]) { seen[s] = true; queue.push(s); }
    for (let head = 0; head < queue.length; head++) {
      const cell = queue[head];
      const r = Math.floor(cell / cols), c = cell % cols;
      for (let d = 0; d < 4; d++) {
        const nr = r + dirs[d], nc = c + dirs[d + 1];
        if (nr < 0 || nr >= rows || nc < 0 || nc >= cols) continue;
        const next = nr * cols + nc;
        if (!seen[next] && heights[nr][nc] >= heights[r][c]) {
          seen[next] = true;
          queue.push(next);
        }
      }
    }
    return seen;
  };
  const pacSeeds: number[] = [], atlSeeds: number[] = [];
  for (let c = 0; c < cols; c++) { pacSeeds.push(c); atlSeeds.push((rows - 1) * cols + c); }
  for (let r = 0; r < rows; r++) { pacSeeds.push(r * cols); atlSeeds.push(r * cols + cols - 1); }
  const pacific = flood(pacSeeds), atlantic = flood(atlSeeds);
  const out: number[][] = [];
  for (let i = 0; i < rows * cols; i++) if (pacific[i] && atlantic[i]) out.push([Math.floor(i / cols), i % cols]);
  return out;
}

export {};
