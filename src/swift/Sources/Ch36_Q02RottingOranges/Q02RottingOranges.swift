// Q2. Rotting Oranges (Offline Update Spread)
// Source: book/part-viii/36-graphs-dynamic-programming.md

func orangesRotting(_ grid: [[Int]]) -> Int {
    var grid = grid // local copy; Swift arrays are values
    let rows = grid.count, cols = grid.first?.count ?? 0
    var queue: [Int] = []
    var fresh = 0
    for r in 0..<rows {
        for c in 0..<cols {
            if grid[r][c] == 2 { queue.append(r * cols + c) }
            else if grid[r][c] == 1 { fresh += 1 }
        }
    }
    let dirs = [1, 0, -1, 0, 1]
    var minutes = 0
    while !queue.isEmpty && fresh > 0 {
        var next: [Int] = [] // the next BFS layer = the next minute
        for cell in queue {
            for d in 0..<4 {
                let nr = cell / cols + dirs[d], nc = cell % cols + dirs[d + 1]
                if nr >= 0 && nr < rows && nc >= 0 && nc < cols && grid[nr][nc] == 1 {
                    grid[nr][nc] = 2
                    fresh -= 1
                    next.append(nr * cols + nc)
                }
            }
        }
        queue = next
        minutes += 1
    }
    return fresh == 0 ? minutes : -1
}
