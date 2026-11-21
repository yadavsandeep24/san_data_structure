// Q6. Course Schedule II (Return Order)
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md

func findOrder(_ numCourses: Int, _ prerequisites: [[Int]]) -> [Int] {
    var g = Array(repeating: [Int](), count: numCourses)
    var indeg = Array(repeating: 0, count: numCourses)
    for e in prerequisites {
        g[e[1]].append(e[0])
        indeg[e[0]] += 1
    }
    var order = (0..<numCourses).filter { indeg[$0] == 0 } // doubles as the queue
    var head = 0
    while head < order.count {
        let u = order[head]
        head += 1
        for v in g[u] {
            indeg[v] -= 1
            if indeg[v] == 0 { order.append(v) }
        }
    }
    return order.count == numCourses ? order : []
}
