// P1: Subsets
// Source: solutions/ch22/README.md

func subsets(_ nums: [Int]) -> [[Int]] {
    var out: [[Int]] = []
    var path: [Int] = []
    func dfs(_ i: Int) {
        if i == nums.count {
            out.append(path)
            return
        }
        dfs(i + 1)
        path.append(nums[i])
        dfs(i + 1)
        path.removeLast()
    }
    dfs(0)
    return out
}
