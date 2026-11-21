// Q3. Longest Consecutive Sequence
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md

func longestConsecutive(_ nums: [Int]) -> Int {
    let set = Set(nums)
    var best = 0
    for x in set {
        if set.contains(x - 1) { continue }
        var y = x
        var len = 1
        while set.contains(y + 1) { y += 1; len += 1 }
        best = max(best, len)
    }
    return best
}
