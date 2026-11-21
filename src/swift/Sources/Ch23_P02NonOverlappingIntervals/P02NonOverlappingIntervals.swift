// P2: Non-overlapping intervals
// Source: solutions/ch23/README.md

func eraseOverlapIntervals(_ intervals: [[Int]]) -> Int {
    if intervals.isEmpty { return 0 }
    let sorted = intervals.sorted { $0[1] < $1[1] }
    var keptEnd = sorted[0][1]
    var removals = 0
    for i in 1..<sorted.count {
        if sorted[i][0] >= keptEnd {
            keptEnd = sorted[i][1]
        } else {
            removals += 1
        }
    }
    return removals
}
