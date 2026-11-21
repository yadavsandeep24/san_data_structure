// Base case + recursive case
// Source: book/part-vi/22-recursion-backtracking.md

int fact(int n) => n <= 1 ? 1 : n * fact(n - 1);
