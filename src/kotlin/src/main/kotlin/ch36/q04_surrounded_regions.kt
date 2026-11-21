// Q4. Surrounded Regions (Paint Bucket Capture)
// Source: book/part-viii/36-graphs-dynamic-programming.md
package ch36.q04_surrounded_regions

fun solve(board: Array<CharArray>) {
    val rows = board.size
    val cols = board[0].size
    val stack = ArrayDeque<Int>()
    fun mark(r: Int, c: Int) {
        if (r !in 0 until rows || c !in 0 until cols || board[r][c] != 'O') return
        board[r][c] = 'S' // safe: connected to the border
        stack.addLast(r * cols + c)
    }
    for (r in 0 until rows) { mark(r, 0); mark(r, cols - 1) }
    for (c in 0 until cols) { mark(0, c); mark(rows - 1, c) }
    while (stack.isNotEmpty()) {
        val cell = stack.removeLast()
        val r = cell / cols
        val c = cell % cols
        mark(r + 1, c); mark(r - 1, c); mark(r, c + 1); mark(r, c - 1)
    }
    for (r in 0 until rows) for (c in 0 until cols) {
        board[r][c] = when (board[r][c]) {
            'S' -> 'O'
            'O' -> 'X' // enclosed
            else -> board[r][c]
        }
    }
}
