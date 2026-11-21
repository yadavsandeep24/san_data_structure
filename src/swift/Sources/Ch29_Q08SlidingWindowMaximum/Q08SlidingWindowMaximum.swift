// Q8. Sliding Window Maximum (Scroll Velocity)
// Source: book/part-viii/29-interview-questions-q01-q10.md

func maxSlidingWindow(_ nums: [Int], _ k: Int) -> [Int] {
    var dq: [Int] = [], head = 0, out: [Int] = []
    for i in nums.indices {
        while head < dq.count && dq[head] <= i - k { head += 1 }
        while head < dq.count && nums[dq[dq.count - 1]] <= nums[i] { dq.removeLast() }
        dq.append(i)
        if i >= k - 1 { out.append(nums[dq[head]]) }
    }
    return out
}
