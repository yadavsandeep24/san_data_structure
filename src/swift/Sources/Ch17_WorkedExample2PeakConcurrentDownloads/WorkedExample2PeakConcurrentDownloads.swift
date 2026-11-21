// Worked example 2: peak concurrent downloads (sweep line)
// Source: book/part-iv/17-intervals-sweep-line.md

func peakConcurrent(_ intervals: [(start: Int, end: Int)]) -> Int {
    var events: [(time: Int, delta: Int)] = []
    events.reserveCapacity(intervals.count * 2)
    for iv in intervals {
        events.append((iv.start, 1))
        events.append((iv.end, -1))
    }
    events.sort { $0.time != $1.time ? $0.time < $1.time : $0.delta < $1.delta }
    var active = 0, peak = 0
    for e in events {
        active += e.delta
        peak = max(peak, active)
    }
    return peak
}
