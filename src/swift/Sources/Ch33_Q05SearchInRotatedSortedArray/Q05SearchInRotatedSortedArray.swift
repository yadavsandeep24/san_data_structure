// Q5. Search in Rotated Sorted Array (Lookup in a Wrapped Log)
// Source: book/part-viii/33-stacks-binary-search.md

func searchRotated(_ nums: [Int], _ target: Int) -> Int {
    var lo = 0, hi = nums.count - 1
    while lo <= hi {
        let mid = lo + (hi - lo) / 2
        if nums[mid] == target { return mid }
        if nums[lo] <= nums[mid] { // left half is sorted
            if target >= nums[lo] && target < nums[mid] { hi = mid - 1 } else { lo = mid + 1 }
        } else {                   // right half is sorted
            if target > nums[mid] && target <= nums[hi] { lo = mid + 1 } else { hi = mid - 1 }
        }
    }
    return -1
}
