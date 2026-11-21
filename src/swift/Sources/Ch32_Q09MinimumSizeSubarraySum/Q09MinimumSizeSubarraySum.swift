// Q9. Minimum Size Subarray Sum (Shortest Run to Reach a Spend Goal)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

func minSubArrayLen(_ target: Int, _ nums: [Int]) -> Int {
    var left = 0
    var sum = 0
    var best = Int.max
    for right in 0..<nums.count {
        sum += nums[right]
        while sum >= target {
            best = min(best, right - left + 1)
            sum -= nums[left]
            left += 1
        }
    }
    return best == Int.max ? 0 : best
}
