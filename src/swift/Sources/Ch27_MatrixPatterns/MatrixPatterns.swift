// Matrix patterns
// Source: book/part-vii/27-bits-matrix.md

func numIslands(_ grid: inout [[Character]]) -> Int {
    let rows = grid.count, cols = grid.first?.count ?? 0
    var count = 0
    func dfs(_ r: Int, _ c: Int) {
        guard r >= 0, c >= 0, r < rows, c < cols, grid[r][c] == "1" else { return }
        grid[r][c] = "0"
        dfs(r + 1, c); dfs(r - 1, c); dfs(r, c + 1); dfs(r, c - 1)
    }
    for r in 0..<rows {
        for c in 0..<cols where grid[r][c] == "1" {
            count += 1
            dfs(r, c)
        }
    }
    return count
}

func rotate(_ matrix: inout [[Int]]) {
    let n = matrix.count
    for i in 0..<n {
        for j in i..<n {
            let t = matrix[i][j]
            matrix[i][j] = matrix[j][i]
            matrix[j][i] = t
        }
    }
    for i in 0..<n {
        matrix[i].reverse()
    }
}

func floodFill(_ image: inout [[Int]], _ sr: Int, _ sc: Int, _ newColor: Int) {
    let old = image[sr][sc]
    if old == newColor { return }
    func dfs(_ r: Int, _ c: Int) {
        guard r >= 0, c >= 0, r < image.count, c < image[0].count, image[r][c] == old else { return }
        image[r][c] = newColor
        dfs(r + 1, c); dfs(r - 1, c); dfs(r, c + 1); dfs(r, c - 1)
    }
    dfs(sr, sc)
}
