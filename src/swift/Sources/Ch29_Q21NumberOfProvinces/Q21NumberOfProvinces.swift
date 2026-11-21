// Q21. Number of Provinces (Connected Components)
// Source: book/part-viii/29-interview-questions-q21-q30.md

func findCircleNum(_ isConnected: [[Int]]) -> Int {
    let n = isConnected.count
    var seen = Array(repeating: false, count: n)
    func dfs(_ i: Int) {
        seen[i] = true
        for j in 0..<n where isConnected[i][j] == 1 && !seen[j] { dfs(j) }
    }
    var provinces = 0
    for i in 0..<n where !seen[i] { provinces += 1; dfs(i) }
    return provinces
}
