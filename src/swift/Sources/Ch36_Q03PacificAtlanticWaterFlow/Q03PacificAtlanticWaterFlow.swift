// Q3. Pacific Atlantic Water Flow (Map Tiles Draining to Both Coasts)
// Source: book/part-viii/36-graphs-dynamic-programming.md

func pacificAtlantic(_ heights: [[Int]]) -> [[Int]] {
    let rows = heights.count, cols = heights.first?.count ?? 0
    let dirs = [1, 0, -1, 0, 1]
    func flood(_ seeds: [Int]) -> [Bool] { // walk uphill from the ocean
        var seen = [Bool](repeating: false, count: rows * cols)
        var queue: [Int] = []
        for s in seeds where !seen[s] { seen[s] = true; queue.append(s) }
        var head = 0
        while head < queue.count {
            let cell = queue[head]; head += 1
            let r = cell / cols, c = cell % cols
            for d in 0..<4 {
                let nr = r + dirs[d], nc = c + dirs[d + 1]
                if nr < 0 || nr >= rows || nc < 0 || nc >= cols { continue }
                let next = nr * cols + nc
                if !seen[next] && heights[nr][nc] >= heights[r][c] {
                    seen[next] = true
                    queue.append(next)
                }
            }
        }
        return seen
    }
    let pacific = flood(Array(0..<cols) + (0..<rows).map { $0 * cols })
    let atlantic = flood((0..<cols).map { (rows - 1) * cols + $0 } + (0..<rows).map { $0 * cols + cols - 1 })
    return (0..<(rows * cols)).filter { pacific[$0] && atlantic[$0] }.map { [$0 / cols, $0 % cols] }
}
