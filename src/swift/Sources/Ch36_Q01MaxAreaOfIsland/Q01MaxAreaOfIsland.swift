// Q1. Max Area of Island (Largest Heatmap Region)
// Source: book/part-viii/36-graphs-dynamic-programming.md

func maxAreaOfIsland(_ grid: [[Int]]) -> Int {
    var grid = grid // local copy; Swift arrays are values
    let rows = grid.count, cols = grid.first?.count ?? 0
    let dirs = [1, 0, -1, 0, 1]
    var best = 0
    for r in 0..<rows {
        for c in 0..<cols where grid[r][c] == 1 {
            grid[r][c] = 2 // visited
            var stack = [r * cols + c]
            var area = 0
            while let cell = stack.popLast() {
                area += 1
                for d in 0..<4 {
                    let nr = cell / cols + dirs[d], nc = cell % cols + dirs[d + 1]
                    if nr >= 0 && nr < rows && nc >= 0 && nc < cols && grid[nr][nc] == 1 {
                        grid[nr][nc] = 2
                        stack.append(nr * cols + nc)
                    }
                }
            }
            best = max(best, area)
        }
    }
    return best
}
