// Climbing stairs
// Source: book/part-vi/24-dynamic-programming.md

function climbStairs(n: number): number {
  if (n <= 2) return n;
  let a = 1, b = 2;
  for (let i = 3; i <= n; i++) {
    const c = a + b; a = b; b = c;
  }
  return b;
}

export {};
