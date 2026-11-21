// Q8. Merge Intervals and Insert Interval Combo
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md

func merge(_ intervals: [[Int]]) -> [[Int]] {
    guard !intervals.isEmpty else { return [] }
    let sorted = intervals.sorted { $0[0] < $1[0] }
    var out = [sorted[0]]
    for cur in sorted.dropFirst() {
        let last = out.count - 1
        if cur[0] <= out[last][1] {
            out[last][1] = max(out[last][1], cur[1])
        } else {
            out.append(cur)
        }
    }
    return out
}

func insert(_ intervals: [[Int]], _ newInterval: [Int]) -> [[Int]] {
    var out: [[Int]] = []
    var i = 0
    let n = intervals.count
    var ns = newInterval[0], ne = newInterval[1]
    while i < n && intervals[i][1] < ns { out.append(intervals[i]); i += 1 }
    while i < n && intervals[i][0] <= ne {
        ns = min(ns, intervals[i][0])
        ne = max(ne, intervals[i][1])
        i += 1
    }
    out.append([ns, ne])
    while i < n { out.append(intervals[i]); i += 1 }
    return out
}
