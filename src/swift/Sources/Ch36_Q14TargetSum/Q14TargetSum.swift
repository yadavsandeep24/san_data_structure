// Q14. Target Sum (Signed Ledger Adjustments)
// Source: book/part-viii/36-graphs-dynamic-programming.md

func findTargetSumWays(_ nums: [Int], _ target: Int) -> Int {
    let total = nums.reduce(0, +)
    if abs(target) > total || (total + target) % 2 != 0 { return 0 }
    let want = (total + target) / 2 // sum of the '+' group
    var ways = [Int](repeating: 0, count: want + 1)
    ways[0] = 1
    for x in nums {
        var s = want
        while s >= x { ways[s] += ways[s - x]; s -= 1 } // 0/1 knapsack, backwards
    }
    return ways[want]
}
