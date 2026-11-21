// P3: Car pooling (capacity check)
// Source: solutions/ch15/README.md

func carPooling(_ trips: [[Int]], _ capacity: Int) -> Bool {
    var diff = [Int](repeating: 0, count: 1001)
    for t in trips {
        diff[t[1]] += t[0]
        diff[t[2]] -= t[0]
    }
    var onBoard = 0
    for d in diff {
        onBoard += d
        if onBoard > capacity { return false }
    }
    return true
}
