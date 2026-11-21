// Q1. Two Sum (Cart SKU Pair)
// Source: book/part-viii/29-interview-questions-q01-q10.md

func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    var seen: [Int: Int] = [:]
    for (i, x) in nums.enumerated() {
        if let j = seen[target - x] { return [j, i] }
        seen[x] = i
    }
    return []
}
