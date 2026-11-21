// Q2. Valid Sudoku (Puzzle Board Check)
// Source: book/part-viii/31-arrays-hashing-matrix.md
package ch31.q02_valid_sudoku

fun isValidSudoku(board: Array<CharArray>): Boolean {
    val rows = IntArray(9)
    val cols = IntArray(9)
    val boxes = IntArray(9)
    for (r in 0 until 9) {
        for (c in 0 until 9) {
            val ch = board[r][c]
            if (ch == '.') continue
            val bit = 1 shl (ch - '1')
            val b = (r / 3) * 3 + c / 3
            if ((rows[r] or cols[c] or boxes[b]) and bit != 0) return false
            rows[r] = rows[r] or bit
            cols[c] = cols[c] or bit
            boxes[b] = boxes[b] or bit
        }
    }
    return true
}
