// Q31. Unique Paths
// Source: book/part-viii/29-interview-questions-q31-q40.md

function uniquePaths(m: number, n: number): number {
  const dp: number[] = Array(n).fill(1);
  for (let i = 1; i < m; i++) for (let j = 1; j < n; j++) dp[j] += dp[j - 1];
  return dp[n - 1];
}

export {};
