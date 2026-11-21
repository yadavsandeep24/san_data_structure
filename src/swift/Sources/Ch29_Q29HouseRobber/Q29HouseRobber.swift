// Q29. House Robber
// Source: book/part-viii/29-interview-questions-q21-q30.md

func rob(_ nums: [Int]) -> Int {
    var prev2 = 0, prev1 = 0
    for x in nums {
        let cur = max(prev1, prev2 + x)
        prev2 = prev1; prev1 = cur
    }
    return prev1
}
