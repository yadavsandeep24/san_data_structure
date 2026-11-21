// Q8. Decode Ways (Ambiguous Numeric Codes)
// Source: book/part-viii/36-graphs-dynamic-programming.md

func numDecodings(_ s: String) -> Int {
    let d = s.compactMap { $0.wholeNumberValue }
    guard d.count == s.count, let first = d.first else { return 0 } // digits only
    var prev2 = 1                   // dp[i-2]
    var prev1 = first == 0 ? 0 : 1  // dp[i-1]
    for i in stride(from: 2, through: d.count, by: 1) {
        var cur = 0
        if d[i - 1] != 0 { cur += prev1 }
        let two = d[i - 2] * 10 + d[i - 1]
        if two >= 10 && two <= 26 { cur += prev2 }
        prev2 = prev1
        prev1 = cur
    }
    return prev1
}
