// Q4. Word Break
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md

func wordBreak(_ s: String, _ wordDict: [String]) -> Bool {
    let dict = Set(wordDict)
    let chars = Array(s)
    let n = chars.count
    var dp = Array(repeating: false, count: n + 1)
    dp[0] = true
    let maxLen = wordDict.map(\.count).max() ?? 0
    for i in 0..<n where dp[i] {
        for len in stride(from: 1, through: min(maxLen, n - i), by: 1) {
            if dict.contains(String(chars[i..<(i + len)])) { dp[i + len] = true }
        }
    }
    return dp[n]
}
