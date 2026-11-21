// P3: First unique character
// Source: solutions/ch07/README.md

func firstUniqChar(_ s: String) -> Int {
    var freq = [Character: Int]()
    for c in s { freq[c, default: 0] += 1 }
    for (i, c) in s.enumerated() where freq[c] == 1 { return i }
    return -1
}
