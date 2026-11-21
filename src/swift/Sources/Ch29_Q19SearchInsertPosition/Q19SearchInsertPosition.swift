// Q19. Search Insert Position (Lower Bound)
// Source: book/part-viii/29-interview-questions-q11-q20.md

func searchInsert(_ nums: [Int], _ target: Int) -> Int {
    var lo = 0, hi = nums.count
    while lo < hi {
        let mid = (lo + hi) / 2
        if nums[mid] < target { lo = mid + 1 } else { hi = mid }
    }
    return lo
}
