// P1: Can attend all meetings
// Source: solutions/ch17/README.md

func canAttendAll(_ meetings: [(start: Int, end: Int)]) -> Bool {
    let sorted = meetings.sorted { $0.start < $1.start }
    for i in sorted.indices.dropFirst() where sorted[i].start < sorted[i - 1].end {
        return false
    }
    return true
}
