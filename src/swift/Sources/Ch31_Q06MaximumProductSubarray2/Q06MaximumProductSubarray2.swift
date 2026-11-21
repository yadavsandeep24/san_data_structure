// Q6 — Maximum product subarray (Swift / Dart)
// Source: solutions/ch31/README.md

func maxProduct(_ nums: [Int]) -> Int {
    var hi = nums[0], lo = nums[0], best = nums[0]
    for x in nums.dropFirst() {
        let a = hi * x, b = lo * x
        hi = max(x, a, b)
        lo = min(x, a, b)
        best = max(best, hi)
    }
    return best
}
