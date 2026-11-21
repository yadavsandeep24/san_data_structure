// Pattern: contains duplicate
// Source: book/part-iii/08-sets.md

func containsDuplicate(_ nums: [Int]) -> Bool {
    var seen = Set<Int>()
    for x in nums {
        if !seen.insert(x).inserted { return true } // inserted == false if already present
    }
    return false
}
