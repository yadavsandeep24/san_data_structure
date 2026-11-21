// Q17. Bus Routes (Hard BFS)
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md

func numBusesToDestination(_ routes: [[Int]], _ source: Int, _ target: Int) -> Int {
    if source == target { return 0 }
    var stopToBus: [Int: [Int]] = [:]
    for (b, route) in routes.enumerated() {
        for s in route { stopToBus[s, default: []].append(b) }
    }
    var q = [source]
    var seenBus = Array(repeating: false, count: routes.count)
    var seenStop: Set<Int> = [source]
    var buses = 0
    while !q.isEmpty {
        buses += 1
        var next: [Int] = []
        for stop in q {
            for b in stopToBus[stop] ?? [] where !seenBus[b] {
                seenBus[b] = true
                for ns in routes[b] {
                    if ns == target { return buses }
                    if seenStop.insert(ns).inserted { next.append(ns) }
                }
            }
        }
        q = next
    }
    return -1
}
