// P2: Network delay time
// Source: solutions/ch25/README.md

func networkDelayTime(_ times: [[Int]], _ n: Int, _ k: Int) -> Int {
    var g = Array(repeating: [(Int, Int)](), count: n + 1)
    for t in times { g[t[0]].append((t[1], t[2])) }
    var dist = Array(repeating: Int.max / 4, count: n + 1)
    dist[k] = 0
    var heap = MinHeapPair()
    heap.push(0, k)
    while let (d, u) = heap.pop() {
        if d > dist[u] { continue }
        for (v, w) in g[u] where d + w < dist[v] {
            dist[v] = d + w
            heap.push(dist[v], v)
        }
    }
    var ans = 0
    for i in 1...n {
        if dist[i] >= Int.max / 4 { return -1 }
        ans = max(ans, dist[i])
    }
    return ans
}

struct MinHeapPair {
    private var a: [(Int, Int)] = []
    mutating func push(_ d: Int, _ u: Int) {
        a.append((d, u)); siftUp(a.count - 1)
    }
    mutating func pop() -> (Int, Int)? {
        guard let first = a.first else { return nil }
        a[0] = a.last!; a.removeLast()
        if !a.isEmpty { siftDown(0) }
        return first
    }
    private mutating func siftUp(_ i: Int) {
        var i = i
        while i > 0 {
            let p = (i - 1) / 2
            if a[i].0 >= a[p].0 { break }
            a.swapAt(i, p); i = p
        }
    }
    private mutating func siftDown(_ i: Int) {
        var i = i
        while true {
            var best = i
            let l = 2 * i + 1, r = l + 1
            if l < a.count && a[l].0 < a[best].0 { best = l }
            if r < a.count && a[r].0 < a[best].0 { best = r }
            if best == i { break }
            a.swapAt(i, best); i = best
        }
    }
}
