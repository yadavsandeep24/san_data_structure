// P3: Rotate image 90 degrees
// Source: solutions/ch27/README.md

func rotate(_ matrix: inout [[Int]]) {
    let n = matrix.count
    for i in 0..<n {
        for j in i..<n {
            let tmp = matrix[i][j]
            matrix[i][j] = matrix[j][i]
            matrix[j][i] = tmp
        }
    }
    for i in 0..<n {
        matrix[i].reverse()
    }
}
