// Q28. Climbing Stairs
// Source: book/part-viii/29-interview-questions-q21-q30.md

function climbStairs(n: number): number {
  if (n <= 2) return n;
  let a = 1, b = 2;
  for (let i = 3; i <= n; i++) { const c = a + b; a = b; b = c; }
  return b;
}

export {};
