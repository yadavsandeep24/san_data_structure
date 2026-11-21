// Matrix patterns
// Source: book/part-vii/27-bits-matrix.md
package ch27.matrix_patterns

fun numIslands(grid: Array<CharArray>): Int {
    var count = 0
    fun dfs(r: Int, c: Int) {
        if (r !in grid.indices || c !in grid[0].indices || grid[r][c] != '1') return
        grid[r][c] = '0'
        dfs(r + 1, c); dfs(r - 1, c); dfs(r, c + 1); dfs(r, c - 1)
    }
    for (r in grid.indices) for (c in grid[0].indices) {
        if (grid[r][c] == '1') {
            count++
            dfs(r, c)
        }
    }
    return count
}

fun rotate(matrix: Array<IntArray>) {
    val n = matrix.size
    for (i in 0 until n) for (j in i until n) {
        val t = matrix[i][j]
        matrix[i][j] = matrix[j][i]
        matrix[j][i] = t
    }
    for (row in matrix) row.reverse()
}

fun floodFill(image: Array<IntArray>, sr: Int, sc: Int, newColor: Int) {
    val old = image[sr][sc]
    if (old == newColor) return
    fun dfs(r: Int, c: Int) {
        if (r !in image.indices || c !in image[0].indices || image[r][c] != old) return
        image[r][c] = newColor
        dfs(r + 1, c); dfs(r - 1, c); dfs(r, c + 1); dfs(r, c - 1)
    }
    dfs(sr, sc)
}
