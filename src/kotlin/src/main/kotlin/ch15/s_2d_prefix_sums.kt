// 2D prefix sums (rectangle queries)
// Source: book/part-iv/15-prefix-sums.md
package ch15.s_2d_prefix_sums

class GridSums(grid: Array<IntArray>) {
    private val p = Array(grid.size + 1) { LongArray((grid.firstOrNull()?.size ?: 0) + 1) }
    init {
        for (r in grid.indices) for (c in grid[r].indices) {
            p[r + 1][c + 1] = grid[r][c] + p[r][c + 1] + p[r + 1][c] - p[r][c]
        }
    }
    fun sum(r1: Int, c1: Int, r2: Int, c2: Int): Long =
        p[r2 + 1][c2 + 1] - p[r1][c2 + 1] - p[r2 + 1][c1] + p[r1][c1]
}
