// P2: First and last position
// Source: solutions/ch21/README.md

func searchRange(_ nums: [Int], _ target: Int) -> [Int] {
    func lower() -> Int {
        var lo = 0, hi = nums.count
        while lo < hi {
            let mid = lo + (hi - lo) / 2
            if nums[mid] < target { lo = mid + 1 } else { hi = mid }
        }
        return lo
    }
    func upper() -> Int {
        var lo = 0, hi = nums.count
        while lo < hi {
            let mid = lo + (hi - lo) / 2
            if nums[mid] <= target { lo = mid + 1 } else { hi = mid }
        }
        return lo
    }
    let L = lower()
    if L == nums.count || nums[L] != target { return [-1, -1] }
    return [L, upper() - 1]
}
