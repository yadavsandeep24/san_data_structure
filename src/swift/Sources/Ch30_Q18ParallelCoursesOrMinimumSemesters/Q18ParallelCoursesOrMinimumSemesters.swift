// Q18. Parallel Courses or Minimum Semesters
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md

func minimumSemesters(_ n: Int, _ relations: [[Int]]) -> Int {
    var g = Array(repeating: [Int](), count: n + 1)
    var indeg = Array(repeating: 0, count: n + 1)
    for e in relations {
        g[e[0]].append(e[1])
        indeg[e[1]] += 1
    }
    var q = stride(from: 1, through: n, by: 1).filter { indeg[$0] == 0 }
    var sem = 0, taken = 0
    while !q.isEmpty {
        sem += 1
        var next: [Int] = []
        for u in q {
            taken += 1
            for v in g[u] {
                indeg[v] -= 1
                if indeg[v] == 0 { next.append(v) }
            }
        }
        q = next
    }
    return taken == n ? sem : -1
}
