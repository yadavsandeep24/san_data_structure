// Q10. First Missing Positive (Next Free Ticket Number)
// Source: book/part-viii/31-arrays-hashing-matrix.md

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
