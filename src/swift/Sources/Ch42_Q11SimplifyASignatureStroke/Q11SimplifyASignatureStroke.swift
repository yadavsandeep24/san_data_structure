// Q11. Simplify a Signature Stroke (Ramer-Douglas-Peucker)
// Source: book/part-ix/42-document-signing-drill-bank-q08-q13.md

struct Pt: Equatable { let x: Double; let y: Double }

func distToSegment(_ p: Pt, _ a: Pt, _ b: Pt) -> Double {
    let dx = b.x - a.x, dy = b.y - a.y
    let len2 = dx * dx + dy * dy
    func len(_ x: Double, _ y: Double) -> Double { (x * x + y * y).squareRoot() }
    if len2 == 0 { return len(p.x - a.x, p.y - a.y) }
    let t = min(1, max(0, ((p.x - a.x) * dx + (p.y - a.y) * dy) / len2))
    return len(p.x - (a.x + t * dx), p.y - (a.y + t * dy))
}

/// Ramer–Douglas–Peucker with an explicit stack, so a long stroke can't overflow the call stack.
func simplify(_ points: [Pt], _ epsilon: Double) -> [Pt] {
    if points.count < 3 { return points }
    var keep = [Bool](repeating: false, count: points.count)
    keep[0] = true; keep[points.count - 1] = true
    var stack = [(0, points.count - 1)]
    while let (s, e) = stack.popLast() {
        var maxD = 0.0, idx = -1
        for i in (s + 1)..<e {
            let d = distToSegment(points[i], points[s], points[e])
            if d > maxD { maxD = d; idx = i }
        }
        if maxD > epsilon { keep[idx] = true; stack.append((s, idx)); stack.append((idx, e)) }
    }
    return points.indices.filter { keep[$0] }.map { points[$0] }
}
