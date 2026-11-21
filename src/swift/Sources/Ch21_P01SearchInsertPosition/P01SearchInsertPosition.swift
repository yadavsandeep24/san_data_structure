// P1: Search insert position
// Source: solutions/ch21/README.md

func searchInsert(_ nums: [Int], _ target: Int) -> Int {
    var lo = 0, hi = nums.count
    while lo < hi {
        let mid = lo + (hi - lo) / 2
        if nums[mid] < target { lo = mid + 1 } else { hi = mid }
    }
    return lo
}
