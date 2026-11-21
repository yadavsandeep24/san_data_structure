// Q8. Spiral Matrix (Onboarding Tile Reveal Order)
// Source: book/part-viii/31-arrays-hashing-matrix.md

func spiralOrder(_ matrix: [[Int]]) -> [Int] {
    var out: [Int] = []
    guard !matrix.isEmpty else { return out }
    var top = 0, bottom = matrix.count - 1
    var left = 0, right = matrix[0].count - 1
    while top <= bottom && left <= right {
        for c in stride(from: left, through: right, by: 1) { out.append(matrix[top][c]) }
        top += 1
        for r in stride(from: top, through: bottom, by: 1) { out.append(matrix[r][right]) }
        right -= 1
        if top <= bottom {
            for c in stride(from: right, through: left, by: -1) { out.append(matrix[bottom][c]) }
            bottom -= 1
        }
        if left <= right {
            for r in stride(from: bottom, through: top, by: -1) { out.append(matrix[r][left]) }
            left += 1
        }
    }
    return out
}
