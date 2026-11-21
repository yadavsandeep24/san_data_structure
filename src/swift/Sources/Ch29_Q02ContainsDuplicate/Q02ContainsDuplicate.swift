// Q2. Contains Duplicate (Dedupe Guard)
// Source: book/part-viii/29-interview-questions-q01-q10.md

func containsDuplicate(_ nums: [Int]) -> Bool {
    var s = Set<Int>()
    for x in nums { if !s.insert(x).inserted { return true } }
    return false
}
