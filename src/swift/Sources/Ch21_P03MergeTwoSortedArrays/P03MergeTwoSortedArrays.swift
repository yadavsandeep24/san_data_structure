// P3: Merge two sorted arrays
// Source: solutions/ch21/README.md

func mergeSorted(_ a: [Int], _ b: [Int]) -> [Int] {
    var i = 0, j = 0
    var out: [Int] = []
    out.reserveCapacity(a.count + b.count)
    while i < a.count && j < b.count {
        if a[i] <= b[j] {
            out.append(a[i]); i += 1
        } else {
            out.append(b[j]); j += 1
        }
    }
    if i < a.count { out.append(contentsOf: a[i...]) }
    if j < b.count { out.append(contentsOf: b[j...]) }
    return out
}
