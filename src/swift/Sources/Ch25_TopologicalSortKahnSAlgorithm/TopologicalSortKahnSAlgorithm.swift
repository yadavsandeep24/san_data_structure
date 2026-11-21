// Topological sort — Kahn’s algorithm
// Source: book/part-vii/25-graphs-advanced.md

func topoSort(_ n: Int, _ edges: [(Int, Int)]) -> [Int]? {
    var g = Array(repeating: [Int](), count: n)
    var indeg = Array(repeating: 0, count: n)
    for (u, v) in edges {
        g[u].append(v)
        indeg[v] += 1
    }
    var q = indeg.indices.filter { indeg[$0] == 0 }
    var order: [Int] = []
    var head = 0
    while head < q.count {
        let u = q[head]; head += 1
        order.append(u)
        for v in g[u] {
            indeg[v] -= 1
            if indeg[v] == 0 { q.append(v) }
        }
    }
    return order.count == n ? order : nil
}
