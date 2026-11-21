// Q11. Minimum Number of Arrows to Burst Balloons (Fewest Sync Ticks)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

func findMinArrowShots(_ points: [[Int]]) -> Int {
    let sorted = points.sorted { $0[1] < $1[1] }
    guard let first = sorted.first else { return 0 }
    var arrows = 1
    var arrowX = first[1]
    for p in sorted where p[0] > arrowX {
        arrows += 1
        arrowX = p[1]
    }
    return arrows
}
