// P3: Phone letter combinations
// Source: solutions/ch22/README.md

func letterCombinations(_ digits: String) -> [String] {
    if digits.isEmpty { return [] }
    let map = ["", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"]
    let chars = Array(digits)
    var out: [String] = []
    var path: [Character] = []
    func dfs(_ i: Int) {
        if i == chars.count {
            out.append(String(path))
            return
        }
        let idx = Int(chars[i].asciiValue! - Character("0").asciiValue!)
        for c in map[idx] {
            path.append(c)
            dfs(i + 1)
            path.removeLast()
        }
    }
    dfs(0)
    return out
}
