// Q27. Meeting Rooms or Min Platforms (Heap)
// Source: book/part-viii/29-interview-questions-q21-q30.md

func minMeetingRooms(_ intervals: [[Int]]) -> Int {
    let sorted = intervals.sorted { $0[0] < $1[0] }
    // Toy min-heap via sorted array — O(n) per push/pop → O(n² log n) worst.
    // Prefer a real binary heap (Chapter 12) for production / large n.
    var ends: [Int] = []
    func push(_ x: Int) { ends.append(x); ends.sort() }
    func popMin() { ends.removeFirst() }
    for (i, iv) in sorted.enumerated() {
        if i == 0 { push(iv[1]); continue }
        if let e = ends.first, iv[0] >= e { popMin() }
        push(iv[1])
    }
    return ends.count
}
