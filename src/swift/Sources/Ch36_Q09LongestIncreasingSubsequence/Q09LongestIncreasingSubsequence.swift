// Q9. Longest Increasing Subsequence (Longest Rising Streak)
// Source: book/part-viii/36-graphs-dynamic-programming.md

func lengthOfLIS(_ nums: [Int]) -> Int {
    var tails: [Int] = [] // tails[k] = smallest tail of an increasing run of length k+1
    for x in nums {
        var lo = 0, hi = tails.count
        while lo < hi {
            let mid = (lo + hi) / 2
            if tails[mid] < x { lo = mid + 1 } else { hi = mid }
        }
        if lo == tails.count { tails.append(x) } else { tails[lo] = x }
    }
    return tails.count
}
