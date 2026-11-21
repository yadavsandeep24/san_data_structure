// Pattern: two-sum with a map
// Source: book/part-iii/07-hash-tables.md

func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    var seen: [Int: Int] = [:]
    for (i, x) in nums.enumerated() {
        if let j = seen[target - x] { return [j, i] }
        seen[x] = i
    }
    return []
}
