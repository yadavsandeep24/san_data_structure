// P3: Valid anagram or first unique character
// Source: solutions/ch26/README.md

func isAnagram(_ s: String, _ t: String) -> Bool {
    guard s.count == t.count else { return false }
    var cnt = [Character: Int]()
    for c in s { cnt[c, default: 0] += 1 }
    for c in t {
        guard let v = cnt[c] else { return false }
        if v == 1 { cnt[c] = nil } else { cnt[c] = v - 1 }
    }
    return cnt.isEmpty
}

func firstUniqChar(_ s: String) -> Int {
    var cnt: [Character: Int] = [:]
    for c in s { cnt[c, default: 0] += 1 }
    for (i, c) in s.enumerated() where cnt[c] == 1 {
        return i
    }
    return -1
}
