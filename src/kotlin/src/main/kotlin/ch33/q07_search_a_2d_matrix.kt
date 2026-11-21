// Q7. Search a 2D Matrix (Paged Sorted Catalogue)
// Source: book/part-viii/33-stacks-binary-search.md
package ch33.q07_search_a_2d_matrix

fun searchMatrix(matrix: Array<IntArray>, target: Int): Boolean {
    if (matrix.isEmpty() || matrix[0].isEmpty()) return false
    val cols = matrix[0].size
    var lo = 0
    var hi = matrix.size * cols - 1
    while (lo <= hi) {
        val mid = lo + (hi - lo) / 2
        val v = matrix[mid / cols][mid % cols] // treat the grid as one sorted array
        when {
            v == target -> return true
            v < target -> lo = mid + 1
            else -> hi = mid - 1
        }
    }
    return false
}
