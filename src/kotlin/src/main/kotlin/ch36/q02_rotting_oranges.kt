// Q2. Rotting Oranges (Offline Update Spread)
// Source: book/part-viii/36-graphs-dynamic-programming.md
package ch36.q02_rotting_oranges

fun orangesRotting(grid: Array<IntArray>): Int {
    val rows = grid.size
    val cols = grid[0].size
    val queue = ArrayDeque<Int>()
    var fresh = 0
    for (r in 0 until rows) for (c in 0 until cols) {
        if (grid[r][c] == 2) queue.addLast(r * cols + c)
        else if (grid[r][c] == 1) fresh++
    }
    val dirs = intArrayOf(1, 0, -1, 0, 1)
    var minutes = 0
    while (queue.isNotEmpty() && fresh > 0) {
        repeat(queue.size) { // one BFS layer = one minute
            val cell = queue.removeFirst()
            for (d in 0..3) {
                val nr = cell / cols + dirs[d]
                val nc = cell % cols + dirs[d + 1]
                if (nr in 0 until rows && nc in 0 until cols && grid[nr][nc] == 1) {
                    grid[nr][nc] = 2
                    fresh--
                    queue.addLast(nr * cols + nc)
                }
            }
        }
        minutes++
    }
    return if (fresh == 0) minutes else -1
}
