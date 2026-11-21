// P2: Number of islands
// Source: solutions/ch27/README.md
package ch27.p02_number_of_islands

fun numIslands(grid: Array<CharArray>): Int {
    if (grid.isEmpty()) return 0
    var count = 0
    fun dfs(r: Int, c: Int) {
        if (r !in grid.indices || c !in grid[0].indices || grid[r][c] != '1') return
        grid[r][c] = '0'
        dfs(r + 1, c)
        dfs(r - 1, c)
        dfs(r, c + 1)
        dfs(r, c - 1)
    }
    for (r in grid.indices) {
        for (c in grid[0].indices) {
            if (grid[r][c] == '1') {
                count++
                dfs(r, c)
            }
        }
    }
    return count
}
