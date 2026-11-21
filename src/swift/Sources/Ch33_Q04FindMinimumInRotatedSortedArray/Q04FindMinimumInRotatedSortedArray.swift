// Q4. Find Minimum in Rotated Sorted Array (Oldest Slot in a Ring Buffer)
// Source: book/part-viii/33-stacks-binary-search.md

func findMin(_ nums: [Int]) -> Int {
    var lo = 0, hi = nums.count - 1
    while lo < hi {
        let mid = lo + (hi - lo) / 2
        if nums[mid] > nums[hi] { lo = mid + 1 } // minimum is right of mid
        else { hi = mid }                        // mid could be the minimum
    }
    return nums[lo]
}
