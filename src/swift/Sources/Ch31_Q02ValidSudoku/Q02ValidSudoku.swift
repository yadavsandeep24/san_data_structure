// Q2. Valid Sudoku (Puzzle Board Check)
// Source: book/part-viii/31-arrays-hashing-matrix.md

func isValidSudoku(_ board: [[Character]]) -> Bool {
    var rows = [Int](repeating: 0, count: 9)
    var cols = [Int](repeating: 0, count: 9)
    var boxes = [Int](repeating: 0, count: 9)
    for r in 0..<9 {
        for c in 0..<9 {
            guard let d = board[r][c].wholeNumberValue, (1...9).contains(d) else { continue }
            let bit = 1 << (d - 1)
            let b = (r / 3) * 3 + c / 3
            if (rows[r] | cols[c] | boxes[b]) & bit != 0 { return false }
            rows[r] |= bit
            cols[c] |= bit
            boxes[b] |= bit
        }
    }
    return true
}
