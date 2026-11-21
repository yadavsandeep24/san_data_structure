// Base case + recursive case
// Source: book/part-vi/22-recursion-backtracking.md
package ch22.base_case_recursive_case

fun fact(n: Int): Long =
    if (n <= 1) 1L else n * fact(n - 1)
