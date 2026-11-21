// P3: Longest consecutive sequence
// Source: solutions/ch08/README.md

func longestConsecutive(_ nums: [Int]) -> Int {
    let set = Set(nums)
    var best = 0
    for x in set where !set.contains(x - 1) {
        var y = x
        var len = 1
        while set.contains(y + 1) {
            y += 1
            len += 1
        }
        best = max(best, len)
    }
    return best
}
