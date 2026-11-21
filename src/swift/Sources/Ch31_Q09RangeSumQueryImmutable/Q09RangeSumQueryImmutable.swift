// Q9. Range Sum Query: Immutable (Statement Range Totals)
// Source: book/part-viii/31-arrays-hashing-matrix.md

final class NumArray {
    private var prefix: [Int]

    init(_ nums: [Int]) {
        prefix = [Int](repeating: 0, count: nums.count + 1)
        for i in 0..<nums.count { prefix[i + 1] = prefix[i] + nums[i] }
    }

    func sumRange(_ left: Int, _ right: Int) -> Int {
        prefix[right + 1] - prefix[left]
    }
}
