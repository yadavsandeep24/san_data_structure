// Q33. Longest Substring Without Repeating Characters
// Source: book/part-viii/29-interview-questions-q31-q40.md

func lengthOfLongestSubstring(_ s: String) -> Int {
    let chars = Array(s)
    var last: [Character: Int] = [:]
    var left = 0, best = 0
    for (i, c) in chars.enumerated() {
        if let p = last[c], p >= left { left = p + 1 }
        last[c] = i
        best = max(best, i - left + 1)
    }
    return best
}
