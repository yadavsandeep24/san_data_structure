// Pattern: number of provinces (connected components)
// Source: book/part-iii/11-graphs-intro.md

func findCircleNum(_ isConnected: [[Int]]) -> Int {
    let n = isConnected.count
    var seen = Array(repeating: false, count: n)
    var count = 0
    func dfs(_ u: Int) {
        seen[u] = true
        for v in 0..<n where isConnected[u][v] == 1 && !seen[v] { dfs(v) }
    }
    for i in 0..<n where !seen[i] {
        count += 1
        dfs(i)
    }
    return count
}
