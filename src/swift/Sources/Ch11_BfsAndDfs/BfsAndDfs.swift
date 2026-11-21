// BFS and DFS
// Source: book/part-iii/11-graphs-intro.md

func bfs(_ graph: [Int: [Int]], start: Int) -> [Int] {
    var seen: Set = [start]
    var q = [start]
    var order: [Int] = []
    var head = 0
    while head < q.count {
        let u = q[head]; head += 1
        order.append(u)
        for v in graph[u] ?? [] where seen.insert(v).inserted {
            q.append(v)                    // mark when enqueued
        }
    }
    return order
}

func dfs(_ graph: [Int: [Int]], start: Int) -> [Int] {
    var seen = Set<Int>()
    var order: [Int] = []
    func go(_ u: Int) {
        seen.insert(u)
        order.append(u)
        for v in graph[u] ?? [] where !seen.contains(v) {
            go(v)
        }
    }
    go(start)
    return order
}
