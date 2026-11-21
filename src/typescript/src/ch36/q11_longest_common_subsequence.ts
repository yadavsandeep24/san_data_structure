// Q11. Longest Common Subsequence (Diffing Two Lists)
// Source: book/part-viii/36-graphs-dynamic-programming.md

function longestCommonSubsequence(a: string, b: string): number {
  const dp = new Array<number>(b.length + 1).fill(0); // row i-1, overwritten into row i
  for (let i = 1; i <= a.length; i++) {
    let diag = 0; // dp[i-1][j-1]
    for (let j = 1; j <= b.length; j++) {
      const up = dp[j]; // dp[i-1][j]
      dp[j] = a[i - 1] === b[j - 1] ? diag + 1 : Math.max(up, dp[j - 1]);
      diag = up;
    }
  }
  return dp[b.length];
}

export {};
