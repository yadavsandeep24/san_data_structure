// P1: Find pivot index
// Source: solutions/ch15/README.md

func pivotIndex(_ a: [Int]) -> Int {
    let total = a.reduce(0, +)
    var left = 0
    for i in a.indices {
        if left == total - left - a[i] { return i }
        left += a[i]
    }
    return -1
}
