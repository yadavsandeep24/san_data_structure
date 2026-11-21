// Pattern: number of provinces (connected components)
// Source: book/part-iii/11-graphs-intro.md

function findCircleNum(isConnected: number[][]): number {
  const n = isConnected.length;
  const seen = Array(n).fill(false);
  let count = 0;
  const dfs = (u: number) => {
    seen[u] = true;
    for (let v = 0; v < n; v++) {
      if (isConnected[u][v] === 1 && !seen[v]) dfs(v);
    }
  };
  for (let i = 0; i < n; i++) {
    if (!seen[i]) {
      count++;
      dfs(i);
    }
  }
  return count;
}

export {};
