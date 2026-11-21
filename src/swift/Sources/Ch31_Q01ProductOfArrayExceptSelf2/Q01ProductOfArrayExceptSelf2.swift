// Q1 — Product of array except self (Swift / Dart)
// Source: solutions/ch31/README.md

func productExceptSelf(_ nums: [Int]) -> [Int] {
    var out = [Int](repeating: 1, count: nums.count)
    var prefix = 1
    for i in 0..<nums.count {
        out[i] = prefix
        prefix *= nums[i]
    }
    var suffix = 1
    for i in stride(from: nums.count - 1, through: 0, by: -1) {
        out[i] *= suffix
        suffix *= nums[i]
    }
    return out
}
