// Q4. Word Break
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md

function wordBreak(s: string, wordDict: string[]): boolean {
  const dict = new Set(wordDict);
  const n = s.length;
  const dp = Array(n + 1).fill(false);
  dp[0] = true;
  const maxLen = wordDict.reduce((m, w) => Math.max(m, w.length), 0);
  for (let i = 0; i < n; i++) {
    if (!dp[i]) continue;
    for (let len = 1; len <= Math.min(maxLen, n - i); len++) {
      if (dict.has(s.slice(i, i + len))) dp[i + len] = true;
    }
  }
  return dp[n];
}

export {};
