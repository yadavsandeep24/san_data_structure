// Q7. Set Matrix Zeroes (Invalidate Grid Rows and Columns)
// Source: book/part-viii/31-arrays-hashing-matrix.md

func setZeroes(_ matrix: inout [[Int]]) {
    guard !matrix.isEmpty else { return }
    let m = matrix.count
    let n = matrix[0].count
    let firstRowZero = matrix[0].contains(0)
    let firstColZero = matrix.contains { $0[0] == 0 }
    for r in 1..<m {
        for c in 1..<n where matrix[r][c] == 0 {
            matrix[r][0] = 0
            matrix[0][c] = 0
        }
    }
    for r in 1..<m {
        for c in 1..<n where matrix[r][0] == 0 || matrix[0][c] == 0 {
            matrix[r][c] = 0
        }
    }
    if firstRowZero { for c in 0..<n { matrix[0][c] = 0 } }
    if firstColZero { for r in 0..<m { matrix[r][0] = 0 } }
}
