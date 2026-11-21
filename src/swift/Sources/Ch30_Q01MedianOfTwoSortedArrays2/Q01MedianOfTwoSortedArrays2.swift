// Q1 — Median of two sorted arrays (Swift / Dart)
// Source: solutions/ch30/README.md

func findMedianSortedArrays(_ a: [Int], _ b: [Int]) -> Double {
    if a.count > b.count { return findMedianSortedArrays(b, a) }
    let m = a.count, n = b.count
    var lo = 0, hi = m
    let half = (m + n + 1) / 2
    while lo <= hi {
        let i = (lo + hi) / 2
        let j = half - i
        let aLeft = i == 0 ? Int.min : a[i - 1]
        let aRight = i == m ? Int.max : a[i]
        let bLeft = j == 0 ? Int.min : b[j - 1]
        let bRight = j == n ? Int.max : b[j]
        if aLeft <= bRight && bLeft <= aRight {
            if (m + n) % 2 == 0 {
                return Double(max(aLeft, bLeft) + min(aRight, bRight)) / 2.0
            }
            return Double(max(aLeft, bLeft))
        } else if aLeft > bRight { hi = i - 1 }
        else { lo = i + 1 }
    }
    fatalError("unreachable")
}
