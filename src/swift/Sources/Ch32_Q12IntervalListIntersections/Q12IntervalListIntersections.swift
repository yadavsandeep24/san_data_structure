// Q12. Interval List Intersections (Shared Free Slots)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

func intervalIntersection(_ a: [[Int]], _ b: [[Int]]) -> [[Int]] {
    var out: [[Int]] = []
    var i = 0, j = 0
    while i < a.count && j < b.count {
        let lo = max(a[i][0], b[j][0])
        let hi = min(a[i][1], b[j][1])
        if lo <= hi { out.append([lo, hi]) }
        if a[i][1] < b[j][1] { i += 1 } else { j += 1 }
    }
    return out
}
