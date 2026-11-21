// Q11. Longest Substring with At Most K Distinct Characters
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md

func lengthOfLongestSubstringKDistinct(_ s: String, _ k: Int) -> Int {
    if k == 0 { return 0 }
    let chars = Array(s)
    var freq: [Character: Int] = [:]
    var lo = 0, best = 0
    for hi in chars.indices {
        freq[chars[hi], default: 0] += 1
        while freq.count > k {
            let c = chars[lo]
            lo += 1
            freq[c, default: 0] -= 1
            if freq[c] == 0 { freq.removeValue(forKey: c) }
        }
        best = max(best, hi - lo + 1)
    }
    return best
}
