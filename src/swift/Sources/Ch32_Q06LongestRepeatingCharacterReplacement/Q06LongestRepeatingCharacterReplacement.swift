// Q6. Longest Repeating Character Replacement (Fix k Typos in a Streak)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

func characterReplacement(_ s: String, _ k: Int) -> Int {
    let b = Array(s.utf8)
    var count = [Int](repeating: 0, count: 26)
    var left = 0
    var maxFreq = 0
    var best = 0
    for right in 0..<b.count {
        let c = Int(b[right] - UInt8(ascii: "A"))
        count[c] += 1
        maxFreq = max(maxFreq, count[c])
        while right - left + 1 - maxFreq > k {
            count[Int(b[left] - UInt8(ascii: "A"))] -= 1
            left += 1
        }
        best = max(best, right - left + 1)
    }
    return best
}
