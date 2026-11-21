// P3: Connected components or redundant connection
// Source: solutions/ch25/README.md

final class UnionFind {
    private var parent: [Int]
    private var rank: [Int]
    private(set) var components: Int
    init(_ n: Int) {
        parent = Array(0..<n)
        rank = Array(repeating: 0, count: n)
        components = n
    }
    func find(_ x: Int) -> Int {
        if parent[x] != x { parent[x] = find(parent[x]) }
        return parent[x]
    }
    @discardableResult
    func union(_ a: Int, _ b: Int) -> Bool {
        var ra = find(a), rb = find(b)
        if ra == rb { return false }
        if rank[ra] < rank[rb] { swap(&ra, &rb) }
        parent[rb] = ra
        if rank[ra] == rank[rb] { rank[ra] += 1 }
        components -= 1
        return true
    }
}

func countComponents(_ n: Int, _ edges: [[Int]]) -> Int {
    let uf = UnionFind(n)
    for e in edges { uf.union(e[0], e[1]) }
    return uf.components
}

func findRedundantConnection(_ edges: [[Int]]) -> [Int] {
    let uf = UnionFind(edges.count + 1)
    for e in edges {
        if !uf.union(e[0], e[1]) { return e }
    }
    return []
}
