// Q24. Shortest Path in Unweighted Graph
// Source: book/part-viii/29-interview-questions-q21-q30.md

func shortestPath(_ g: [Int: [Int]], _ start: Int, _ end: Int) -> Int {
    if start == end { return 0 }
    var seen: Set = [start]
    var q = [start]
    var head = 0, dist = 0
    while head < q.count {
        let size = q.count - head
        for _ in 0..<size {
            let u = q[head]; head += 1
            for v in g[u] ?? [] {
                if v == end { return dist + 1 }
                if seen.insert(v).inserted { q.append(v) }
            }
        }
        dist += 1
    }
    return -1
}
