// Worked example 1: merge busy blocks
// Source: book/part-iv/17-intervals-sweep-line.md

func mergeBusy(_ blocks: [(start: Int, end: Int)]) -> [(start: Int, end: Int)] {
    let sorted = blocks.sorted { $0.start < $1.start }
    var out: [(start: Int, end: Int)] = []
    for b in sorted {
        if let last = out.last, b.start <= last.end {
            out[out.count - 1].end = max(last.end, b.end)
        } else {
            out.append(b)
        }
    }
    return out
}
