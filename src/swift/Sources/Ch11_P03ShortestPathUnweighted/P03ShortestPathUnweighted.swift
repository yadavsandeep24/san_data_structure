// P3: Shortest path unweighted
// Source: solutions/ch11/README.md

func shortestPath(
    _ graph: [String: [String]],
    src: String,
    dst: String
) -> (dist: Int, path: [String])? {
    if src == dst { return (0, [src]) }
    var parent: [String: String?] = [src: nil]
    var q = [src]
    var head = 0
    while head < q.count {
        let u = q[head]; head += 1
        for v in graph[u] ?? [] where parent[v] == nil {
            parent[v] = u
            if v == dst {
                var path = [String]()
                var cur: String? = dst
                while let c = cur {
                    path.append(c)
                    cur = parent[c] ?? nil
                }
                path.reverse()
                return (path.count - 1, path)
            }
            q.append(v)
        }
    }
    return nil
}
