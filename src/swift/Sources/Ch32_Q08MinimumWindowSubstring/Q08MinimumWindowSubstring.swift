// Q8. Minimum Window Substring (Shortest Log Span Covering All Events)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

func minWindow(_ s: String, _ t: String) -> String {
    let sa = Array(s.utf8), ta = Array(t.utf8)
    if ta.isEmpty || ta.count > sa.count { return "" }
    var need = [Int](repeating: 0, count: 256)
    for c in ta { need[Int(c)] += 1 }
    var missing = ta.count
    var left = 0, bestStart = 0, bestLen = Int.max
    for right in 0..<sa.count {
        if need[Int(sa[right])] > 0 { missing -= 1 }
        need[Int(sa[right])] -= 1
        while missing == 0 {
            if right - left + 1 < bestLen {
                bestLen = right - left + 1
                bestStart = left
            }
            need[Int(sa[left])] += 1
            if need[Int(sa[left])] > 0 { missing += 1 }
            left += 1
        }
    }
    if bestLen == Int.max { return "" }
    return String(decoding: sa[bestStart..<bestStart + bestLen], as: UTF8.self)
}
