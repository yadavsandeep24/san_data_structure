// Q4. Surrounded Regions (Paint Bucket Capture)
// Source: book/part-viii/36-graphs-dynamic-programming.md

func solve(_ board: inout [[Character]]) {
    let rows = board.count, cols = board.first?.count ?? 0
    var stack: [Int] = []
    func mark(_ r: Int, _ c: Int) {
        if r < 0 || r >= rows || c < 0 || c >= cols || board[r][c] != "O" { return }
        board[r][c] = "S" // safe: connected to the border
        stack.append(r * cols + c)
    }
    for r in 0..<rows { mark(r, 0); mark(r, cols - 1) }
    for c in 0..<cols { mark(0, c); mark(rows - 1, c) }
    while let cell = stack.popLast() {
        let r = cell / cols, c = cell % cols
        mark(r + 1, c); mark(r - 1, c); mark(r, c + 1); mark(r, c - 1)
    }
    for r in 0..<rows {
        for c in 0..<cols {
            if board[r][c] == "S" { board[r][c] = "O" }
            else if board[r][c] == "O" { board[r][c] = "X" } // enclosed
        }
    }
}
