// Q5. Maximum Subarray (Best Trading Streak)
// Source: book/part-viii/31-arrays-hashing-matrix.md

func maxSubArray(_ nums: [Int]) -> Int {
    var best = nums[0]
    var cur = nums[0]
    for x in nums.dropFirst() {
        cur = max(x, cur + x)
        best = max(best, cur)
    }
    return best
}
