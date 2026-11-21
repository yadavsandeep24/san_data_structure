// P3: Sort colors (three-way partition)
// Source: solutions/ch13/README.md

func sortColors(_ a: inout [Int]) {
    var low = 0, mid = 0, high = a.count - 1
    while mid <= high {
        switch a[mid] {
        case 0:
            a.swapAt(low, mid); low += 1; mid += 1
        case 1:
            mid += 1
        default:
            a.swapAt(mid, high); high -= 1
        }
    }
}
