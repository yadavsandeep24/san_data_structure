// Q5. Word Search II (Word Game Board Scan)
// Source: book/part-viii/35-heaps-tries-greedy.md

type WNode = { next: Map<string, WNode>; word: string | null };

function findWords(board: string[][], words: string[]): string[] {
  const root: WNode = { next: new Map(), word: null };
  for (const w of words) {
    let cur = root;
    for (const c of w) {
      if (!cur.next.has(c)) cur.next.set(c, { next: new Map(), word: null });
      cur = cur.next.get(c)!;
    }
    cur.word = w;
  }
  const rows = board.length, cols = board[0].length;
  const found: string[] = [];
  const dfs = (r: number, c: number, parent: WNode): void => {
    const ch = board[r][c];
    const node = parent.next.get(ch); // '#' is never a trie edge
    if (!node) return;
    if (node.word !== null) {
      found.push(node.word);
      node.word = null; // report once
    }
    board[r][c] = "#";
    if (r > 0) dfs(r - 1, c, node);
    if (r < rows - 1) dfs(r + 1, c, node);
    if (c > 0) dfs(r, c - 1, node);
    if (c < cols - 1) dfs(r, c + 1, node);
    board[r][c] = ch;
  };
  for (let r = 0; r < rows; r++) for (let c = 0; c < cols; c++) dfs(r, c, root);
  return found;
}

export {};
