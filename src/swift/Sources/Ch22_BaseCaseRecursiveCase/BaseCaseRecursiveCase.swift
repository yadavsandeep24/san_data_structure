// Base case + recursive case
// Source: book/part-vi/22-recursion-backtracking.md

func fact(_ n: Int) -> Int {
    n <= 1 ? 1 : n * fact(n - 1)
}
