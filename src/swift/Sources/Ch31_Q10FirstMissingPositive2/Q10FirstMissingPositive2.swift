// Q10 — First missing positive (Swift / Dart)
// Source: solutions/ch31/README.md

func firstMissingPositive(_ input: [Int]) -> Int {
    var nums = input
    let n = nums.count
    for i in 0..<n {
        while nums[i] >= 1 && nums[i] <= n && nums[nums[i] - 1] != nums[i] {
            nums.swapAt(i, nums[i] - 1)
        }
    }
    for i in 0..<n where nums[i] != i + 1 { return i + 1 }
    return n + 1
}
