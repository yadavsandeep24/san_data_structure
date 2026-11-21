// P2: Contiguous array (equal 0s and 1s)
// Source: solutions/ch15/README.md

func findMaxLength(_ a: [Int]) -> Int {
    var first: [Int: Int] = [0: -1]
    var prefix = 0, best = 0
    for i in a.indices {
        prefix += a[i] == 1 ? 1 : -1
        if let f = first[prefix] {
            best = max(best, i - f)
        } else {
            first[prefix] = i
        }
    }
    return best
}
