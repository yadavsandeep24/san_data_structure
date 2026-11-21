// Classic patterns
// Source: book/part-ii/06-queues-deques.md

func maxSlidingWindow(_ nums: [Int], _ k: Int) -> [Int] {
    guard !nums.isEmpty, k > 0 else { return [] }
    var dq: [Int] = [], head = 0, res: [Int] = []
    for i in nums.indices {
        while head < dq.count && dq[head] <= i - k { head += 1 }
        while head < dq.count && nums[dq[dq.count - 1]] <= nums[i] { dq.removeLast() }
        dq.append(i)
        if i >= k - 1 { res.append(nums[dq[head]]) }
    }
    return res
}
