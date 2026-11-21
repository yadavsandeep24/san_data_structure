// Pattern: shortest path in unweighted graph
// Source: book/part-iii/11-graphs-intro.md

func shortestHops(_ g: [String: [String]], _ src: String, _ dst: String) -> Int? {
    if src == dst { return 0 }
    var dist = [src: 0]
    var q = [src]
    var head = 0
    while head < q.count {
        let u = q[head]; head += 1
        let du = dist[u] ?? 0
        for v in g[u] ?? [] where dist[v] == nil {
            dist[v] = du + 1
            if v == dst { return du + 1 }
            q.append(v)
        }
    }
    return nil // unreachable
}
