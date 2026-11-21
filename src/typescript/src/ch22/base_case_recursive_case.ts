// Base case + recursive case
// Source: book/part-vi/22-recursion-backtracking.md

function fact(n: number): number {
  return n <= 1 ? 1 : n * fact(n - 1); // exact through 22!, but past 18! it exceeds MAX_SAFE_INTEGER — use bigint
}

export {};
