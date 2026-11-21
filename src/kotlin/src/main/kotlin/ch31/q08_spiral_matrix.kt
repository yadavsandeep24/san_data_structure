// Q8. Spiral Matrix (Onboarding Tile Reveal Order)
// Source: book/part-viii/31-arrays-hashing-matrix.md
package ch31.q08_spiral_matrix

fun spiralOrder(matrix: Array<IntArray>): List<Int> {
    val out = mutableListOf<Int>()
    if (matrix.isEmpty()) return out
    var top = 0
    var bottom = matrix.size - 1
    var left = 0
    var right = matrix[0].size - 1
    while (top <= bottom && left <= right) {
        for (c in left..right) out.add(matrix[top][c])
        top++
        for (r in top..bottom) out.add(matrix[r][right])
        right--
        if (top <= bottom) {
            for (c in right downTo left) out.add(matrix[bottom][c])
            bottom--
        }
        if (left <= right) {
            for (r in bottom downTo top) out.add(matrix[r][left])
            left++
        }
    }
    return out
}
