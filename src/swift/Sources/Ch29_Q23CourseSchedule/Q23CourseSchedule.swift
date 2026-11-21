// Q23. Course Schedule (Cycle Detect)
// Source: book/part-viii/29-interview-questions-q21-q30.md

func canFinish(_ numCourses: Int, _ prerequisites: [[Int]]) -> Bool {
    var adj = Array(repeating: [Int](), count: numCourses)
    var indeg = Array(repeating: 0, count: numCourses)
    for e in prerequisites { adj[e[1]].append(e[0]); indeg[e[0]] += 1 }
    var q: [Int] = []
    for i in 0..<numCourses where indeg[i] == 0 { q.append(i) }
    var seen = 0, head = 0
    while head < q.count {
        let u = q[head]; head += 1; seen += 1
        for v in adj[u] { indeg[v] -= 1; if indeg[v] == 0 { q.append(v) } }
    }
    return seen == numCourses
}
