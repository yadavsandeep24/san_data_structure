// Worked: letter combinations (sketch)
// Source: book/part-vi/22-recursion-backtracking.md

func letterCombinations(_ digits: String) -> [String] {
    if digits.isEmpty { return [] }
    let map = ["", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"]
    let ds = digits.compactMap(\.wholeNumberValue)
    var out: [String] = []
    var path = ""
    func dfs(_ i: Int) {
        if i == ds.count { out.append(path); return }
        for c in map[ds[i]] {
            path.append(c)
            dfs(i + 1)
            path.removeLast()
        }
    }
    dfs(0)
    return out
}
