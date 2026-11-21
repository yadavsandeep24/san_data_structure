// P3: Rotate image 90 degrees
// Source: solutions/ch27/README.md
package ch27.p03_rotate_image_90_degrees

fun rotate(matrix: Array<IntArray>) {
    val n = matrix.size
    for (i in 0 until n) {
        for (j in i until n) {
            val tmp = matrix[i][j]
            matrix[i][j] = matrix[j][i]
            matrix[j][i] = tmp
        }
    }
    for (row in matrix) row.reverse()
}
