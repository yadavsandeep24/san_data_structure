// Q7. House Robber II (Circular Carousel Ad Slots)
// Source: book/part-viii/36-graphs-dynamic-programming.md

func rob(_ nums: [Int]) -> Int {
    if nums.count == 1 { return nums[0] }
    func robLine(_ from: Int, _ to: Int) -> Int {
        var prev = 0, best = 0 // best up to i-2, best up to i-1
        for i in stride(from: from, through: to, by: 1) {
            let take = prev + nums[i]
            prev = best
            best = max(best, take)
        }
        return best
    }
    return max(robLine(0, nums.count - 2), robLine(1, nums.count - 1))
}
