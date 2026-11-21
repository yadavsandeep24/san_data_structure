// Q1. Max Area of Island (Largest Heatmap Region)
// Source: book/part-viii/36-graphs-dynamic-programming.md
package ch36.q01_max_area_of_island

fun maxAreaOfIsland(grid: Array<IntArray>): Int {
    val rows = grid.size
    val cols = grid[0].size
    val dirs = intArrayOf(1, 0, -1, 0, 1)
    val stack = ArrayDeque<Int>()
    var best = 0
    for (r in 0 until rows) for (c in 0 until cols) {
        if (grid[r][c] != 1) continue
        grid[r][c] = 2 // visited
        stack.addLast(r * cols + c)
        var area = 0
        while (stack.isNotEmpty()) {
            val cell = stack.removeLast()
            area++
            for (d in 0..3) {
                val nr = cell / cols + dirs[d]
                val nc = cell % cols + dirs[d + 1]
                if (nr in 0 until rows && nc in 0 until cols && grid[nr][nc] == 1) {
                    grid[nr][nc] = 2
                    stack.addLast(nr * cols + nc)
                }
            }
        }
        best = maxOf(best, area)
    }
    return best
}
