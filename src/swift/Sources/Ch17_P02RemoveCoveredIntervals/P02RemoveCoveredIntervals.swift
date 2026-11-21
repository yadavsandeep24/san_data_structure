// P2: Remove covered intervals
// Source: solutions/ch17/README.md

func removeCoveredIntervals(_ intervals: [(start: Int, end: Int)]) -> Int {
    let sorted = intervals.sorted { $0.start != $1.start ? $0.start < $1.start : $0.end > $1.end }
    var maxEnd = Int.min, kept = 0
    for iv in sorted where iv.end > maxEnd {
        kept += 1
        maxEnd = iv.end
    }
    return kept
}
