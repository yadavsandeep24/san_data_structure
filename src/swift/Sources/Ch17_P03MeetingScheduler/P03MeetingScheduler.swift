// P3: Meeting scheduler (two calendars)
// Source: solutions/ch17/README.md

func meetingScheduler(_ slotsA: [(start: Int, end: Int)], _ slotsB: [(start: Int, end: Int)], _ duration: Int) -> (start: Int, end: Int)? {
    let a = slotsA.sorted { $0.start < $1.start }
    let b = slotsB.sorted { $0.start < $1.start }
    var i = 0, j = 0
    while i < a.count && j < b.count {
        let start = max(a[i].start, b[j].start)
        let end = min(a[i].end, b[j].end)
        if end - start >= duration { return (start, start + duration) }
        if a[i].end < b[j].end { i += 1 } else { j += 1 }
    }
    return nil
}
