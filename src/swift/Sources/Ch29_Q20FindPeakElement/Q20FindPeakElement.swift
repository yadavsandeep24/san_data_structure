// Q20. Find Peak Element
// Source: book/part-viii/29-interview-questions-q11-q20.md

func findPeakElement(_ nums: [Int]) -> Int {
    var lo = 0, hi = nums.count - 1
    while lo < hi {
        let mid = (lo + hi) / 2
        if nums[mid] < nums[mid + 1] { lo = mid + 1 } else { hi = mid }
    }
    return lo
}
