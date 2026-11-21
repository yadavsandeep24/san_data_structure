// Q2. K Closest Points to Origin (Nearest Stores on the Map)
// Source: book/part-viii/35-heaps-tries-greedy.md

// uses Heap<T> from Q1
func kClosest(_ points: [[Int]], _ k: Int) -> [[Int]] {
    func dist(_ p: [Int]) -> Int { p[0] * p[0] + p[1] * p[1] }
    var heap = Heap<[Int]> { dist($0) > dist($1) } // max-heap by distance
    for p in points {
        heap.push(p)
        if heap.count > k { heap.pop() } // drop the farthest
    }
    var out: [[Int]] = []
    while let p = heap.pop() { out.append(p) }
    return out
}
