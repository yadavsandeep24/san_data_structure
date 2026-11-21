// P2: Combination sum
// Source: solutions/ch22/README.md

func combinationSum(_ candidates: [Int], _ target: Int) -> [[Int]] {
    let nums = candidates.sorted()
    var out: [[Int]] = []
    var path: [Int] = []
    func dfs(_ start: Int, _ remain: Int) {
        if remain == 0 {
            out.append(path)
            return
        }
        for j in start..<nums.count {
            let c = nums[j]
            if c > remain { break }
            path.append(c)
            dfs(j, remain - c)
            path.removeLast()
        }
    }
    dfs(0, target)
    return out
}
