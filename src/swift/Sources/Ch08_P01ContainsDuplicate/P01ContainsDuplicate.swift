// P1: Contains duplicate
// Source: solutions/ch08/README.md

func containsDuplicate(_ nums: [Int]) -> Bool {
    var seen = Set<Int>()
    for x in nums {
        if !seen.insert(x).inserted { return true }
    }
    return false
}
