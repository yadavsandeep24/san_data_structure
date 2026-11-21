// Q7. Set Matrix Zeroes (Invalidate Grid Rows and Columns)
// Source: book/part-viii/31-arrays-hashing-matrix.md
package ch31.q07_set_matrix_zeroes

fun setZeroes(matrix: Array<IntArray>) {
    if (matrix.isEmpty()) return
    val m = matrix.size
    val n = matrix[0].size
    val firstRowZero = (0 until n).any { matrix[0][it] == 0 }
    val firstColZero = (0 until m).any { matrix[it][0] == 0 }
    for (r in 1 until m) for (c in 1 until n) {
        if (matrix[r][c] == 0) {
            matrix[r][0] = 0
            matrix[0][c] = 0
        }
    }
    for (r in 1 until m) for (c in 1 until n) {
        if (matrix[r][0] == 0 || matrix[0][c] == 0) matrix[r][c] = 0
    }
    if (firstRowZero) for (c in 0 until n) matrix[0][c] = 0
    if (firstColZero) for (r in 0 until m) matrix[r][0] = 0
}
