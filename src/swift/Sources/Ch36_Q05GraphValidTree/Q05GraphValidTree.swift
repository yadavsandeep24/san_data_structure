// Q5. Graph Valid Tree (Folder Hierarchy Sanity Check)
// Source: book/part-viii/36-graphs-dynamic-programming.md

func validTree(_ n: Int, _ edges: [[Int]]) -> Bool {
    if edges.count != n - 1 { return false }
    var parent = Array(0..<n)
    var size = [Int](repeating: 1, count: n)
    func find(_ x: Int) -> Int {
        var r = x
        while parent[r] != r {
            parent[r] = parent[parent[r]] // path halving
            r = parent[r]
        }
        return r
    }
    for e in edges {
        let ra = find(e[0]), rb = find(e[1])
        if ra == rb { return false } // edge closes a cycle
        if size[ra] < size[rb] { // union by size: hang the smaller tree
            parent[ra] = rb
            size[rb] += size[ra]
        } else {
            parent[rb] = ra
            size[ra] += size[rb]
        }
    }
    return true
}
