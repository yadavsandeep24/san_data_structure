// Q4. Surrounded Regions (Paint Bucket Capture)
// Source: book/part-viii/36-graphs-dynamic-programming.md

function solve(board: string[][]): void {
  const rows = board.length, cols = board[0].length;
  const stack: number[] = [];
  const mark = (r: number, c: number): void => {
    if (r < 0 || r >= rows || c < 0 || c >= cols || board[r][c] !== "O") return;
    board[r][c] = "S"; // safe: connected to the border
    stack.push(r * cols + c);
  };
  for (let r = 0; r < rows; r++) { mark(r, 0); mark(r, cols - 1); }
  for (let c = 0; c < cols; c++) { mark(0, c); mark(rows - 1, c); }
  while (stack.length > 0) {
    const cell = stack.pop()!;
    const r = Math.floor(cell / cols), c = cell % cols;
    mark(r + 1, c); mark(r - 1, c); mark(r, c + 1); mark(r, c - 1);
  }
  for (const row of board) {
    for (let c = 0; c < cols; c++) row[c] = row[c] === "S" ? "O" : row[c] === "O" ? "X" : row[c];
  }
}

export {};
