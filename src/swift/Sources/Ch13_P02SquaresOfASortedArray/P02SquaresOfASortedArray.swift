// P2: Squares of a sorted array
// Source: solutions/ch13/README.md

func sortedSquares(_ a: [Int]) -> [Int] {
    var out = [Int](repeating: 0, count: a.count)
    var lo = 0, hi = a.count - 1
    var pos = a.count - 1
    while pos >= 0 {
        let l = a[lo] * a[lo], h = a[hi] * a[hi]
        if l > h { out[pos] = l; lo += 1 } else { out[pos] = h; hi -= 1 }
        pos -= 1
    }
    return out
}
