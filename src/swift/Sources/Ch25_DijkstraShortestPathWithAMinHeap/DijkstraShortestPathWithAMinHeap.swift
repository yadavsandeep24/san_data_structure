// Dijkstra — shortest path with a min-heap
// Source: book/part-vii/25-graphs-advanced.md

func networkDelayTime(_ times: [[Int]], _ n: Int, _ k: Int) -> Int {
    var g = Array(repeating: [(Int, Int)](), count: n + 1)
    for t in times { g[t[0]].append((t[1], t[2])) }
    var dist = Array(repeating: Int.max, count: n + 1)
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
    let ans = dist.dropFirst().max()!
    return ans == Int.max ? -1 : ans
}
// MinHeapPair: same sift as Chapter 12, storing (dist, node)
