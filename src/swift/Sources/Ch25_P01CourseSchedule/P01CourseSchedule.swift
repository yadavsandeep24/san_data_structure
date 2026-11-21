// P1: Course schedule
// Source: solutions/ch25/README.md

func canFinish(_ numCourses: Int, _ prerequisites: [[Int]]) -> Bool {
    var g = Array(repeating: [Int](), count: numCourses)
    var indeg = Array(repeating: 0, count: numCourses)
    for p in prerequisites {
        let a = p[0], b = p[1]
        g[b].append(a)
        indeg[a] += 1
    }
    var q = indeg.indices.filter { indeg[$0] == 0 }
    var head = 0, seen = 0
    while head < q.count {
        let u = q[head]; head += 1
        seen += 1
        for v in g[u] {
            indeg[v] -= 1
            if indeg[v] == 0 { q.append(v) }
        }
    }
    return seen == numCourses
}
