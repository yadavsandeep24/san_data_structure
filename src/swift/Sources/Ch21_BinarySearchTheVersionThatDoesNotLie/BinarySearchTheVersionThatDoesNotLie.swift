// Binary search — the version that does not lie
// Source: book/part-vi/21-searching-sorting.md

func searchInsert(_ nums: [Int], _ target: Int) -> Int {
    var lo = 0, hi = nums.count
    while lo < hi {
        let mid = lo + (hi - lo) / 2
        if nums[mid] < target { lo = mid + 1 } else { hi = mid }
    }
    return lo
}
