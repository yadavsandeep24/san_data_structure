// P2: Number of islands
// Source: solutions/ch27/README.md

func numIslands(_ grid: [[Character]]) -> Int {
    var g = grid
    guard !g.isEmpty else { return 0 }
    let rows = g.count, cols = g[0].count
    var count = 0
    func dfs(_ r: Int, _ c: Int) {
        if r < 0 || c < 0 || r >= rows || c >= cols || g[r][c] != "1" { return }
        g[r][c] = "0"
        dfs(r + 1, c); dfs(r - 1, c); dfs(r, c + 1); dfs(r, c - 1)
    }
    for r in 0..<rows {
        for c in 0..<cols where g[r][c] == "1" {
            count += 1
            dfs(r, c)
        }
    }
    return count
}
