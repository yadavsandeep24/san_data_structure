// Q6. Jump Game II (Fewest Deep-Link Hops)
// Source: book/part-viii/35-heaps-tries-greedy.md

func jump(_ nums: [Int]) -> Int {
    var jumps = 0
    var curEnd = 0   // last index reachable with `jumps` jumps
    var farthest = 0 // last index reachable with one more jump
    for i in 0..<max(0, nums.count - 1) {
        farthest = max(farthest, i + nums[i])
        if i == curEnd {
            jumps += 1
            curEnd = farthest
        }
    }
    return jumps
}
