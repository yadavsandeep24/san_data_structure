// Q3. Pacific Atlantic Water Flow (Map Tiles Draining to Both Coasts)
// Source: book/part-viii/36-graphs-dynamic-programming.md
package ch36.q03_pacific_atlantic_water_flow

fun pacificAtlantic(heights: Array<IntArray>): List<List<Int>> {
    val rows = heights.size
    val cols = heights[0].size
    val dirs = intArrayOf(1, 0, -1, 0, 1)
    fun flood(seeds: List<Int>): BooleanArray { // walk uphill from the ocean
        val seen = BooleanArray(rows * cols)
        val queue = ArrayDeque<Int>()
        for (s in seeds) if (!seen[s]) { seen[s] = true; queue.addLast(s) }
        while (queue.isNotEmpty()) {
            val cell = queue.removeFirst()
            val r = cell / cols
            val c = cell % cols
            for (d in 0..3) {
                val nr = r + dirs[d]
                val nc = c + dirs[d + 1]
                if (nr !in 0 until rows || nc !in 0 until cols) continue
                val next = nr * cols + nc
                if (!seen[next] && heights[nr][nc] >= heights[r][c]) {
                    seen[next] = true
                    queue.addLast(next)
                }
            }
        }
        return seen
    }
    val pacific = flood((0 until cols).toList() + (0 until rows).map { it * cols })
    val atlantic = flood((0 until cols).map { (rows - 1) * cols + it } + (0 until rows).map { it * cols + cols - 1 })
    val out = mutableListOf<List<Int>>()
    for (i in 0 until rows * cols) if (pacific[i] && atlantic[i]) out += listOf(i / cols, i % cols)
    return out
}
