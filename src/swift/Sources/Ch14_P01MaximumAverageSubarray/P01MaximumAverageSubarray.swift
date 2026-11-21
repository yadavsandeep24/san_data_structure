// P1: Maximum average subarray
// Source: solutions/ch14/README.md

func findMaxAverage(_ nums: [Int], _ k: Int) -> Double {
    var sum = 0
    for i in 0..<k { sum += nums[i] }
    var best = sum
    for r in k..<nums.count {
        sum += nums[r] - nums[r - k]
        best = max(best, sum)
    }
    return Double(best) / Double(k)
}
