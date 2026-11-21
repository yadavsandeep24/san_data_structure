// Q10. Combination Sum IV (Ordered Top-Up Sequences)
// Source: book/part-viii/36-graphs-dynamic-programming.md

func combinationSum4(_ nums: [Int], _ target: Int) -> Int {
    var ways = [Int](repeating: 0, count: target + 1)
    ways[0] = 1
    for t in stride(from: 1, through: target, by: 1) {
        for x in nums where x <= t { ways[t] &+= ways[t - x] } // x is the last step; &+= wraps, never traps
    }
    return ways[target]
}
