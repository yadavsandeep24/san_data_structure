// Q21. Number of Provinces (Connected Components)
// Source: book/part-viii/29-interview-questions-q21-q30.md

function findCircleNum(isConnected: number[][]): number {
  const n = isConnected.length;
  const seen: boolean[] = Array(n).fill(false);
  function dfs(i: number): void {
    seen[i] = true;
    for (let j = 0; j < n; j++) if (isConnected[i][j] === 1 && !seen[j]) dfs(j);
  }
  let provinces = 0;
  for (let i = 0; i < n; i++) if (!seen[i]) { provinces++; dfs(i); }
  return provinces;
}

export {};
