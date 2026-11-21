// Q6. Maximum Product Subarray (Compounded Multiplier Streak)
// Source: book/part-viii/31-arrays-hashing-matrix.md

func maxProduct(_ nums: [Int]) -> Int {
    var hi = nums[0], lo = nums[0], best = nums[0]
    for x in nums.dropFirst() {
        let a = hi * x, b = lo * x
        hi = max(x, a, b)
        lo = min(x, a, b)
        best = max(best, hi)
    }
    return best
}
