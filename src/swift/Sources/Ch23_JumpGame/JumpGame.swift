// Jump game (mobile-relevant framing)
// Source: book/part-vi/23-greedy-thinking.md

func canJump(_ nums: [Int]) -> Bool {
    var farthest = 0
    for i in nums.indices {
        if i > farthest { return false }
        farthest = max(farthest, i + nums[i])
        if farthest >= nums.count - 1 { return true }
    }
    return true
}
