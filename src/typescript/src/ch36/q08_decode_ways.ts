// Q8. Decode Ways (Ambiguous Numeric Codes)
// Source: book/part-viii/36-graphs-dynamic-programming.md

function numDecodings(s: string): number {
  let prev2 = 1;                      // dp[i-2]
  let prev1 = s[0] === "0" ? 0 : 1;   // dp[i-1]
  for (let i = 2; i <= s.length; i++) {
    let cur = 0;
    if (s[i - 1] !== "0") cur += prev1;
    const two = Number(s.slice(i - 2, i));
    if (two >= 10 && two <= 26) cur += prev2;
    prev2 = prev1;
    prev1 = cur;
  }
  return prev1;
}

export {};
